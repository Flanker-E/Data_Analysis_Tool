function varargout = Data_Analysis_Tool_3(varargin)
% DATA_ANALYSIS_TOOL_3 MATLAB code for Data_Analysis_Tool_3.fig
%      DATA_ANALYSIS_TOOL_3, by itself, creates a new DATA_ANALYSIS_TOOL_3 or raises the existing
%      singleton*.
%


%      H = DATA_ANALYSIS_TOOL_3 returns the handle to a new DATA_ANALYSIS_TOOL_3 or the handle to
%     
%the existing singleton*.
%
%      DATA_ANALYSIS_TOOL_3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_ANALYSIS_TOOL_3.M with the given input arguments.
%
%      DATA_ANALYSIS_TOOL_3('Property','Value',...) creates a new DATA_ANALYSIS_TOOL_3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Data_Analysis_Tool_3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Data_Analysis_Tool_3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Data_Analysis_Tool_3

% Last Modified by GUIDE v2.5 24-Sep-2020 19:23:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Data_Analysis_Tool_3_OpeningFcn, ...
                   'gui_OutputFcn',  @Data_Analysis_Tool_3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Data_Analysis_Tool_3 is made visible.是在程序运行时，就开始执行
function Data_Analysis_Tool_3_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for Data_Analysis_Tool_3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = Data_Analysis_Tool_3_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in FileSelection.
function FileSelection_Callback(hObject, eventdata, handles)
%filename存放打开的文件名  pathname存放路径
[filename,filepath]=uigetfile('*.mat','select recorded data');
%uigetfile(filter,title)
file=fullfile(filepath,filename);
%得到字符串形式的完整文件路径
set(handles.FileDirectory,'String',file,'FontSize',10);
%set(H,Name,Value)
%将文件名及目录打印到上面text框里，并设置对应句柄的名字以及赋值
load(file);
vars=whos;
%whos用于列出当前工作空间中所有变量，以及它们的名字以及尺寸（比如矩阵或数组的
%行列维数）、所占字节数、属性等信息。这些信息都显示在matlab中的workspace窗口中
n=0;
% TimeBase=0;
for i=1:length(vars)
    try %看是否是CAN信号
        eval([vars(i).name,'.unit;'])
        %可以返回单位，vars(i).name返回''的struct名，后接.unit;
        %即'MCRL_ActualV_00_MCRL_ActualV_01.unit'
        n=n+1;
        List{n}=vars(i).name;
        y=eval([List{n},'.signals.values;']);
%         if TimeBase==0||length(y)<TimeBase
%             TimeBase=length(y);
%         end
%         keyboard
    catch
    end
%try
%     % 尝试执行的语句E
%catch
%     % 如果E运行错误
%     % 执行catch和end之间的代码块
%end
end
% keyboard
guidata(hObject,handles);% 保存句柄的变化
set(handles.ParaList,'String',List);
% 设置下拉选择目录，内容为list
ErrorTime=[;];% 创建记录出错的时间即错误号的矩阵
MotorList=[];% 记录电机数据存在，作为电机下拉选择目录的内容
k=0;
MotorName='';
% ErrorHavePrinted=0;% 只打印检测到的第一个有错误的电机图像
TimeBase=0;
for i=1:length(List)
% 打印默认图像2，因为默认图像二包含出错时间信息，故第一个打印；
    if contains(List{i}, 'Diagnos')
%         strcmp(List{i}, 'MCRL_ActualV_01_MCRL_Diagnos_00')
        %strfind查找字符串2在字符串1中的位置并以数组返回，isempty判断数组是否为空
       if contains(List{i}, 'MCFL')% 找到所有记录到的电机
            MotorName='MCFL';
            k=k+1;
            MotorList{k}='MCFL';
            set(handles.text11,'BackgroundColor','green');% 让Err背景变成绿色，显示读到数据
        elseif contains(List{i}, 'MCFR')
            MotorName='MCFR';
            k=k+1;
            MotorList{k}='MCFR';
            set(handles.text13,'BackgroundColor','green');% 让Err背景变成绿色，显示读到数据
        elseif contains(List{i}, 'MCRL')
            MotorName='MCRL';
            k=k+1;
            MotorList{k}='MCRL';
            set(handles.text14,'BackgroundColor','green');% 让Err背景变成绿色，显示读到数据
        elseif contains(List{i}, 'MCRR')
            MotorName='MCRR';
            k=k+1;
            MotorList{k}='MCRR';
            set(handles.text15,'BackgroundColor','green');% 让Err背景变成绿色，显示读到数据
        end
        ErrorTime=[ErrorTime {MotorName;0;0;0}];% 创建记录出错的时间即错误号的矩阵
        ParaName=List{i};
        axes(handles.Plot4)
%         cla reset 
        x=eval([ParaName,'.time;']);
        %x_Unit={'s'};
        y=eval([ParaName,'.signals.values;']);
        TimeBase=length(y);
%         %y_Unit=eval([ParaName,'.unit;']);
%         p1=plot(x,y);
%         hold on;
%         Plot4name=[MotorName ' Diagnos'];
%         title(Plot4name,'FontSize',8);
    end
    if contains(List{i}, 'ErrorIn')
%         ~isempty(strfind(List{i}, 'ErrorIn'))
%         strcmp(List{i}, 'MCRL_ActualV_01_MCRL_ErrorIn_01')
        ParaName=List{i};
        TimeErrorOccurs=0;
        yErrorIn=eval([ParaName,'.signals.values;']);
        for m=2:length(y)% 找出diagnostic变化的一点并根据ErrorIn标注
           n=m-1;
           if y(m)~=y(n)&&y(m)~=0
               TimeErrorOccurs=TimeErrorOccurs+1;
               str={['t:',num2str(x(m))],['Diagno:',num2str(y(m))],['ErrIn:',num2str(yErrorIn(m))]};
               text(x(m)+0.2,y(m),str,'FontSize',8);% 出错坐标
               plot(x(m),y(m),'-o')% 出错坐标画圆标注
               if TimeErrorOccurs>1
                   ErrorTime=[ErrorTime {MotorName;0;0;0}];
               end
               ErrorTime{2,end}=m;
               ErrorTime{3,end}=y(m);
               ErrorTime{4,end}=yErrorIn(m);
               % 记录出错坐标点及对应错误，用来在其他图上标注出错时间点，方便发现错误
               % ******注意******：m为记录坐标，x(m)为记录坐标对应的时间
               % 因为起始时间不定，故plot使用实际时间x(m)标记坐标点，寻找值使用记录坐标m
               if contains(MotorName, 'MCFL')
                    set(handles.text11,'BackgroundColor','red');% 让Err背景变成红色，显示有错误
                elseif contains(MotorName, 'MCFR')
                    set(handles.text13,'BackgroundColor','red');
                elseif contains(MotorName, 'MCRL')
                    set(handles.text14,'BackgroundColor','red');
                elseif contains(MotorName, 'MCRR')
                    set(handles.text15,'BackgroundColor','red');
                end
           end
        end
    end
end
% keyboard
for i=size(ErrorTime,2):-1:1
    if ErrorTime{2,i}==0
        ErrorTime(:,i)=[];
    end
end
set(handles.ParaListMotor,'String',MotorList);
% keyboard

if isempty(ErrorTime)% 若没有错误码
    for i=1:length(List)
        if contains(List{i}, MotorName)&& contains(List{i},'Diagno')
            ParaName=List{i};
            axes(handles.Plot4)
            cla reset 
            x=eval([ParaName,'.time;']);
            %x_Unit={'s'};
            y=eval([ParaName,'.signals.values;']);
%             TimeBase=length(y);
            %y_Unit=eval([ParaName,'.unit;']);
            plot(x,y);
            hold on;
            title([MotorName ' Diagnos'],'FontSize',8);
        end
        % 打印默认图像1
        if  contains(List{i}, MotorName)&& ...
            (contains(List{i},['_' MotorName '_ActualV_01'])||contains(List{i},'_ActualVe'))
%             contains(List{i}, 'ActualV_01')
            ParaName=List{i};
            axes(handles.Plot3)
            cla reset
            x=eval([ParaName,'.time;']);
            %x_Unit={'s'};
            y=eval([ParaName,'.signals.values;']);
            y_Unit=eval([ParaName,'.unit;']);
            plot(x,y);
            hold on
%             McNameidx=strfind(List{i},MotorName);
%             MotorName=List{i}(McNameidx:McNameidx+3)
            title([MotorName ' ActualV'],'FontSize',8);
        end
        % 打印默认图像3
        if contains(List{i}, MotorName)&&contains(List{i},'ActualT')
            ParaName=List{i};
            axes(handles.Plot5)
            cla reset % 清空图像
            x=eval([ParaName,'.time;']);
            %x_Unit={'s'};
            y=eval([ParaName,'.signals.values;']);
            y_Unit=eval([ParaName,'.unit;']);
            plot(x,y)
            hold on
%             McNameidx=strfind(List{i},'MC');
%             MotorName=List{i}(McNameidx:McNameidx+3)
            title([MotorName ' ActualT'],'FontSize',8);
        end
    end
else
    ErrorTimeIdx=(strfind([ErrorTime{1,:}],MotorName)+3)/4;
    for i=1:length(List)
        if contains(List{i}, MotorName)&& contains(List{i},'Diagnos')
            ParaName=List{i};
            axes(handles.Plot4)
            cla reset 
            x=eval([ParaName,'.time;']);
            %x_Unit={'s'};
            y=eval([ParaName,'.signals.values;']);
%             TimeBase=length(y);
            y_Unit=eval([ParaName,'.unit;']);
            plot(x,y);
            hold on;
            if ~isempty(ErrorTimeIdx)
                stem(x([ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}]),y([ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}])); 
                % 因为ErrorTime第一列存储的是数据坐标，x()才是存储的时间
                for n=ErrorTimeIdx(1):ErrorTimeIdx(end)
                     % 查找这个电机出现错误次数
                    str={['t:',num2str(x(ErrorTime{2,n}))],[ y_Unit,':',num2str(y(ErrorTime{2,n}))],...
                        ['Diagno:',num2str(ErrorTime{3,n}),'-',num2str(ErrorTime{4,n})]};
                    text(x(ErrorTime{2,n})+0.2,y(ErrorTime{2,n}),str,'FontSize',8);
                    % 出错坐标,'Color',[0 0.4470 0.7410]
                end
            end
            title([MotorName ' Diagnos'],'FontSize',8);
        end
        % 打印默认图像1
        if contains(List{i}, MotorName)&& ...
            (contains(List{i},['_' MotorName '_ActualV_01'])||contains(List{i},'_ActualVe'))
            ParaName=List{i};
            axes(handles.Plot3)
            cla reset
            x=eval([ParaName,'.time;']);
            %x_Unit={'s'};
            y=eval([ParaName,'.signals.values;']);
            y_Unit=eval([ParaName,'.unit;']);
            plot(x,y)
            hold on
    %         if ~isempty(ErrorTime)% 不为空则执行
            ratio=length(y)/TimeBase; % 根据数据采集密度转换时间计量
            if ratio<0.6
                ratio=round(ratio*100)/100;
            else
                ratio=round(ratio);
            end
            if ~isempty(ErrorTimeIdx)
                stem(x(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}])),...
                y(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}]))); 
                % 因为ErrorTime第一列存储的是数据坐标，x()才是存储的时间
                for n=ErrorTimeIdx(1):ErrorTimeIdx(end)
                     % 查找这个电机出现错误次数
                    str={['t:',num2str(x(round(ratio.*ErrorTime{2,n})))],[ y_Unit,':',num2str(y(round(ratio.*ErrorTime{2,n})))],...
                        ['Diagno:',num2str(ErrorTime{3,n}),'-',num2str(ErrorTime{4,n})]};
                    text(x(round(ratio.*ErrorTime{2,n}))+0.2,y(round(ratio.*ErrorTime{2,n})),str,'FontSize',8);
                    % 出错坐标,'Color',[0 0.4470 0.7410]
                end
            end
            title([MotorName ' ActualV'],'FontSize',8);
        end

        % 打印默认图像3
        if contains(List{i}, MotorName)&& contains(List{i},'ActualT')
            ParaName=List{i};
            axes(handles.Plot5)
            cla reset % 清空图像
            x=eval([ParaName,'.time;']);
            %x_Unit={'s'};
            y=eval([ParaName,'.signals.values;']);
            y_Unit=eval([ParaName,'.unit;']);
            plot(x,y)
            hold on
            ratio=length(y)/TimeBase; % 根据数据采集密度转换时间计量
            if ratio<0.6
                ratio=round(ratio*100)/100;
            else
                ratio=round(ratio);
            end
            if ~isempty(ErrorTimeIdx)
                stem(x(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}])),...
                y(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}]))); 
                % 因为ErrorTime第一列存储的是数据坐标，x()才是存储的时间
                for n=ErrorTimeIdx(1):ErrorTimeIdx(end)
                     % 查找这个电机出现错误次数
                    str={['t:',num2str(x(round(ratio.*ErrorTime{2,n})))],[ y_Unit,':',num2str(y(round(ratio.*ErrorTime{2,n})))],...
                        ['Diagno:',num2str(ErrorTime{3,n}),'-',num2str(ErrorTime{4,n})]};
                    text(x(round(ratio.*ErrorTime{2,n}))+0.2,y(round(ratio.*ErrorTime{2,n})),str,'FontSize',8);
                    % 出错坐标,'Color',[0 0.4470 0.7410]
                end
            end
            title([MotorName ' ActualT'],'FontSize',8);
        end
    end
end
handles.TimeBase=TimeBase;
handles.TimeRange=x(end)+1;
handles.ErrorTime=ErrorTime;
% handles.TimeBase=TimeBase;% 把变量存储进句柄
handles.List=List;
p1={};p2={};
handles.Plot1plots=p1;%创建空cell，用于记录每次plot的句柄，用以区分stem进行legend
handles.Plot2plots=p2;
LegendName1={};LegendName2={};
handles.Plot1legend=LegendName1;
handles.Plot2legend=LegendName2;
guidata(hObject,handles);% 保存句柄的变化
% keyboard % 取消注释可以在这里中断使用command window进行操作
set(handles.text12,'String',['data ends at ',num2str(handles.TimeRange),' s']);
% 显示试车数据时间
%global Name2

% --- Executes on selection change in SelectedParaList.
function SelectedParaList_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function SelectedParaList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% 初始化时设置颜色背景


% --- Executes on selection change in ParaList.
function ParaList_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns ParaList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ParaList


% --- Executes during object creation, after setting all properties.
function ParaList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotButton.
function PlotButton_Callback(hObject, eventdata, handles)
% 加载数据
file=get(handles.FileDirectory,'String');
% get查询图形对象属性
load(file);
% 从选择模块那里得到选择的变量
String=get(handles.ParaList,'String');
% Paralist中所有的cell array
Index=get(handles.ParaList,'Value');
% 取出Paralist选中的那个对应的值
ParaName=String{Index};
% 取出名字字符串
% 对SelectedParaList的数据进行处理
List=get(handles.SelectedParaList,'String');
% 一个被选择的数据的cell
List{length(List)+1}=ParaName;

set(handles.SelectedParaList,'String',List)
%keyboard
% 确定现在选择的电机（显示错误码）
MotorString=get(handles.ParaListMotor,'String');
% Paralist中所有的cell array
MotorIndex=get(handles.ParaListMotor,'Value');
% 取出Paralist选中的那个对应的值
MotorName=MotorString{MotorIndex};
% 取出名字字符串
ErrorTimeIdx=(strfind([handles.ErrorTime{1,:}],MotorName)+3)/4;
%List=handles.List;
TimeBase=handles.TimeBase;
ErrorTime=handles.ErrorTime;

axes(handles.Plot1)
p1=handles.Plot1plots;
LegendName1=handles.Plot1legend;
%p1=get(handles.Plot1plots,'none');
x=eval([ParaName,'.time;']);
%x_Unit={'s'};
y=eval([ParaName,'.signals.values;']);
y_Unit=eval([ParaName,'.unit;']);

p=plot(x,y);
p1{length(p1)+1}=p;

index=strfind(ParaName,'_');
tmp=ParaName;
LegendName1{length(LegendName1)+1}=tmp(index(end-1)+1:index(end)-1);
LegendName1=strrep(LegendName1,'_',' ');
% 把1中的3换成2（1、2、3指输入变量顺序）

handles.Plot1legend=LegendName1;
handles.Plot1plots=p1;
guidata(hObject,handles);% 保存句柄的变化
%set(handles.Plot1plots,'none',p1);
hold on
% keyboard
if ~isempty(ErrorTimeIdx)
    ratio=length(y)/TimeBase; % 根据数据采集密度转换时间计量
    if ratio<0.6
        ratio=round(ratio*100)/100;
    else
        ratio=round(ratio);
    end
    
    if (ratio*ErrorTime{2,ErrorTimeIdx(end)})>length(x)
        ErrorTimeIdx(end)=[];
    end
    
    stem(x(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}])),...
        y(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}]))); 
    % 因为ErrorTime第一列存储的是数据坐标，x()才是存储的时间
    for n=ErrorTimeIdx(1):ErrorTimeIdx(end)
         % 查找这个电机出现错误次数
        str={['t:',num2str(x(round(ratio.*ErrorTime{2,n})))],[ y_Unit,':',num2str(y(round(ratio.*ErrorTime{2,n})))]};
        text(x(round(ratio.*ErrorTime{2,n}))+0.2,y(round(ratio.*ErrorTime{2,n})),str,'FontSize',8);
        % 出错坐标,'Color',[0 0.4470 0.7410]
    end
end
% keyboard
legend([p1{:}],LegendName1);
%legend(h,string_matrix) 用字符矩阵参量string_matrix的每一行字符串作为标签给
%包含于句柄向量h中的相应的图形对象加标签
%legend对每个记录下的plot句柄匹配一个Name进行标注
%legend第一个只识别数组[]形式下的plot句柄，故将cell所有内容用[]装起来


% --- Executes on button press in ClearPlot.
function ClearPlot_Callback(hObject, eventdata, handles)
axes(handles.Plot1)
cla reset
handles.Plot1legend={};
handles.Plot1plots={};
guidata(hObject,handles);% 保存句柄的变化
set(handles.SelectedParaList,'String','')

% --- Executes during object creation, after setting all properties.
function Plot1_CreateFcn(hObject, eventdata, handles)
% set(hObject,'toolbar','figure') 


% Hint: place code in OpeningFcn to populate Plot1


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)


% --- Executes on selection change in SelectedParaList2.
function SelectedParaList2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function SelectedParaList2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotButton2.
function PlotButton2_Callback(hObject, eventdata, handles)
% 加载数据
file=get(handles.FileDirectory,'String');
load(file);
% 从选择模块那里得到选择的变量
String=get(handles.ParaList,'String');
Index=get(handles.ParaList,'Value');
ParaName=String{Index};

% % 对SelectedParaList的数据进行处理
% List=get(handles.SelectedParaList2,'String');
% % 一个被选择的数据的cell
% List{length(List)+1}=ParaName;
% 
% set(handles.SelectedParaList2,'String',List)
%keyboard
% 确定现在选择的电机（显示错误码）
MotorString=get(handles.ParaListMotor,'String');
% Paralist中所有的cell array
MotorIndex=get(handles.ParaListMotor,'Value');
% 取出Paralist选中的那个对应的值
MotorName=MotorString{MotorIndex};
% 取出名字字符串
ErrorTimeIdx=(strfind([handles.ErrorTime{1,:}],MotorName)+3)/4;
%List=handles.List;
TimeBase=handles.TimeBase;
ErrorTime=handles.ErrorTime;

axes(handles.Plot2)
p2=handles.Plot2plots;
LegendName2=handles.Plot2legend;
x=eval([ParaName,'.time;']);
%x_Unit={'s'};
y=eval([ParaName,'.signals.values;']);
y_Unit=eval([ParaName,'.unit;']);
p=plot(x,y);
p2{length(p2)+1}=p;

index=strfind(ParaName,'_');
tmp=ParaName;
LegendName2{length(LegendName2)+1}=tmp(index(end-1)+1:index(end)-1);
LegendName2=strrep(LegendName2,'_',' ');
% 把1中的3换成2（1、2、3指输入变量顺序）

handles.Plot2legend=LegendName2;
handles.Plot2plots=p2;
guidata(hObject,handles);% 保存句柄的变化
hold on;
%keyboard
if ~isempty(ErrorTimeIdx)
    ratio=length(y)/TimeBase; % 根据数据采集密度转换时间计量
    if ratio<0.6
        ratio=round(ratio*100)/100;
    else
        ratio=round(ratio);
    end
    if (ratio*ErrorTime{2,ErrorTimeIdx(end)})>length(x)
        ErrorTimeIdx(end)=[];
    end
    stem(x(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}])),...
        y(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}]))); 
    % 因为ErrorTime第一列存储的是数据坐标，x()才是存储的时间
    for n=ErrorTimeIdx(1):ErrorTimeIdx(end)
         % 查找这个电机出现错误次数
        str={['t:',num2str(x(round(ratio.*ErrorTime{2,n})))],[ y_Unit,':',num2str(y(round(ratio.*ErrorTime{2,n})))]};
        text(x(round(ratio.*ErrorTime{2,n}))+0.2,y(round(ratio.*ErrorTime{2,n})),str,'FontSize',8);
        % 出错坐标,'Color',[0 0.4470 0.7410]
    end
end

% 对SelectedParaList的数据进行处理
List=get(handles.SelectedParaList2,'String');
List{length(List)+1}=ParaName;
set(handles.SelectedParaList2,'String',List);

legend([p2{:}],LegendName2);
% 标注信号名称

% --- Executes on button press in ClearPlot2.
function ClearPlot2_Callback(hObject, eventdata, handles)
axes(handles.Plot2)
cla reset
handles.Plot2legend={};
handles.Plot2plots={};
guidata(hObject,handles);% 保存句柄的变化
set(handles.SelectedParaList2,'String','')


function Start_Time_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Start_Time_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function End_Time_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function End_Time_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
TimeRange=handles.TimeRange;
StartTimeRaw=get(handles.Start_Time,'String');
EndTimeRaw=get(handles.End_Time,'String');
% 如果输入default则显示初始plot范围
keyboard
if strcmp(StartTimeRaw, 'DEFAULT') || strcmp(StartTimeRaw, 'Default') || ...
        strcmp(StartTimeRaw, 'default')
    StartTime=0;
else
    StartTime=str2double(StartTimeRaw);
end
if strcmp(EndTimeRaw, 'DEFAULT') || strcmp(EndTimeRaw, 'Default') || ...
        strcmp(EndTimeRaw, 'default')
    EndTime=TimeRange;
else
    EndTime=str2double(EndTimeRaw);
end
axes(handles.Plot1)
xlim([StartTime,EndTime]);
axes(handles.Plot2)
xlim([StartTime,EndTime]);
axes(handles.Plot3)
xlim([StartTime,EndTime]);
axes(handles.Plot4)
xlim([StartTime,EndTime]);
axes(handles.Plot5)
xlim([StartTime,EndTime]);


% --- Executes during object creation, after setting all properties.
function PlotButton_CreateFcn(hObject, eventdata, handles)

% --- Executes during object deletion, before destroying properties.
function PlotButton_DeleteFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function text11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Plot3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Plot3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Plot3


% --- Executes on selection change in ParaListMotor.
function ParaListMotor_Callback(hObject, eventdata, handles)
% 加载数据
file=get(handles.FileDirectory,'String');
% get查询图形对象属性
load(file);
% 从选择模块那里得到选择的变量
String=get(handles.ParaListMotor,'String');
% Paralist中所有的cell array
Index=get(handles.ParaListMotor,'Value');
% 取出Paralist选中的那个对应的值
MotorName=String{Index};
% 取出名字字符串
ErrorTimeIdx=(strfind([handles.ErrorTime{1,:}],MotorName)+3)/4;
List=handles.List;
TimeBase=handles.TimeBase;
ErrorTime=handles.ErrorTime;
% TimeErrorOccurs=length(ErrorTimeIdx); 
for i=1:length(List)
    if contains(List{i}, MotorName)&& contains(List{i},'Diagnos')
        ParaName=List{i};
        axes(handles.Plot4)
        cla reset 
        x=eval([ParaName,'.time;']);
        %x_Unit={'s'};
        y=eval([ParaName,'.signals.values;']);
        TimeBase=length(y);
        %y_Unit=eval([ParaName,'.unit;']);
        plot(x,y);
        hold on;
        if ~isempty(ErrorTimeIdx)
            stem(x([ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}]),y([ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}])); 
            % 因为ErrorTime第一列存储的是数据坐标，x()才是存储的时间
            for n=ErrorTimeIdx(1):ErrorTimeIdx(end)
                 % 查找这个电机出现错误次数
                str={['t:',num2str(x(ErrorTime{2,n}))],[ y_Unit,':',num2str(y(ErrorTime{2,n}))],...
                    ['Diagno:',num2str(ErrorTime{3,n}),'-',num2str(ErrorTime{4,n})]};
                text(x(ErrorTime{2,n})+0.2,y(ErrorTime{2,n}),str,'FontSize',8);
                % 出错坐标,'Color',[0 0.4470 0.7410]
            end
        end
        title([MotorName ' Diagnos'],'FontSize',8);
    end
    % 打印默认图像1
    if contains(List{i}, MotorName)&& ...
            (contains(List{i},['_' MotorName '_ActualV_01'])||contains(List{i},'_ActualVe'))
        ParaName=List{i};
        axes(handles.Plot3)
        cla reset
        x=eval([ParaName,'.time;']);
        %x_Unit={'s'};
        y=eval([ParaName,'.signals.values;']);
        y_Unit=eval([ParaName,'.unit;']);
        plot(x,y)
        hold on
        if ~isempty(ErrorTimeIdx)% 不为空则执行
            ratio=length(y)/TimeBase; % 根据数据采集密度转换时间计量
            if ratio<0.6
                ratio=round(ratio*100)/100;
            else
                ratio=round(ratio);
            end
            stem(x(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}])),...
                y(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}]))); 
            % 因为ErrorTime第一列存储的是数据坐标，x()才是存储的时间
            for n=ErrorTimeIdx(1):ErrorTimeIdx(end)
                 % 查找这个电机出现错误次数
                str={['t:',num2str(x(round(ratio.*ErrorTime{2,n})))],[ y_Unit,':',num2str(y(round(ratio.*ErrorTime{2,n})))],...
                    ['Diagno:',num2str(ErrorTime{3,n}),'-',num2str(ErrorTime{4,n})]};
                text(x(round(ratio.*ErrorTime{2,n}))+0.2,y(round(ratio.*ErrorTime{2,n})),str,'FontSize',8);
                % 出错坐标,'Color',[0 0.4470 0.7410]
            end
        end
        title([MotorName ' ActualV'],'FontSize',8);
    end

    % 打印默认图像3
    if contains(List{i}, MotorName)&& contains(List{i},'ActualT')
        ParaName=List{i};
        axes(handles.Plot5)
        cla reset % 清空图像
        x=eval([ParaName,'.time;']);
        %x_Unit={'s'};
        y=eval([ParaName,'.signals.values;']);
        y_Unit=eval([ParaName,'.unit;']);
        plot(x,y)
        hold on
        if ~isempty(ErrorTimeIdx)
            ratio=length(y)/TimeBase; % 根据数据采集密度转换时间计量
            if ratio<0.6
                ratio=round(ratio*100)/100;
            else
                ratio=round(ratio);
            end
            stem(x(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}])),...
                y(round(ratio.*[ErrorTime{2,ErrorTimeIdx(1):ErrorTimeIdx(end)}]))); 
            % 因为ErrorTime第一列存储的是数据坐标，x()才是存储的时间
            for n=ErrorTimeIdx(1):ErrorTimeIdx(end)
                 % 查找这个电机出现错误次数
                str={['t:',num2str(x(round(ratio.*ErrorTime{2,n})))],[ y_Unit,':',num2str(y(round(ratio.*ErrorTime{2,n})))],...
                    ['Diagno:',num2str(ErrorTime{3,n}),'-',num2str(ErrorTime{4,n})]};
                text(x(round(ratio.*ErrorTime{2,n}))+0.2,y(round(ratio.*ErrorTime{2,n})),str,'FontSize',8);
                % 出错坐标,'Color',[0 0.4470 0.7410]
            end
        end
        title([MotorName ' ActualT'],'FontSize',8);
    end
end
% set(handles.SelectedParaList,'String',List)


% Hints: contents = cellstr(get(hObject,'String')) returns ParaListMotor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ParaListMotor


% --- Executes during object creation, after setting all properties.
function ParaListMotor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ParaListMotor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
