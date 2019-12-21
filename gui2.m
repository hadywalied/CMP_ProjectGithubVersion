function varargout = gui2(varargin)
% GUI2 MATLAB code for gui2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2

% Last Modified by GUIDE v2.5 19-Dec-2019 12:57:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui2_OpeningFcn, ...
    'gui_OutputFcn',  @gui2_OutputFcn, ...
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


% --- Executes just before gui2 is made visible.
function gui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2 (see VARARGIN)

% Choose default command line output for gui2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_strart.
function btn_strart_Callback(hObject, eventdata, handles)
% hObject    handle to btn_strart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
workspace = guidata(hObject);

if workspace.type== 0 %UART
    workspace.Frame = UartFrameFormater(workspace.stream,workspace.parity ...
        ,workspace.stopBits,workspace.numBits);
    stream= workspace.Frame(:);
    
elseif workspace.type== 1 %USB
    workspace.Frame = USBFrameFormater(workspace.stream);
    workspace.Frame = bitStuff(workspace.Frame);
    [workspace.Dplus,workspace.Dminus]= DLinesGenerator(workspace.Frame);
    stream = [workspace.Dplus(1:16) ; workspace.Dminus(1:16)]';
else
    
end
handels.hObject = stairs(stream);
legend('D+' , 'D-')
ylim([-1 2])
xlim([1 16])
handels.output = hObject;
guidata(hObject, handles);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
workspace = guidata(hObject);
val = get(hObject , 'Value');

if val == 2
    workspace.type = 0;
elseif val == 3
    workspace.type = 1;
end
% switch str{val}
%     case 'UART'
%         workspace.type = 0 ;
%     case 'USB'
%         workspace.type = 1 ;
%end
guidata(hObject,workspace);



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
workspace = guidata(hObject);
workspace.eff= 1;
for i = 1:6
    workspace.Stream = repmat(workspace.stream,1,i);
    if workspace.type== 0 %UART
        workspace.Frame = UartFrameFormater(workspace.Stream,workspace.parity ...
            ,workspace.stopBits,workspace.numBits);
        %stream= workspace.Frame(:);
        
    elseif workspace.type== 1 %USB
        workspace.Frame = USBFrameFormater(workspace.Stream);
        workspace.Frame = bitStuff(workspace.Frame);
        [workspace.Dplus,workspace.Dminus]= DLinesGenerator(workspace.Frame);
        % stream = [workspace.Dplus(1:16) ; workspace.Dminus(1:16)]';
    else
        
    end
    workspace.eff(i) = ceil(length(workspace.Stream) /length(workspace.Frame(:)));
end
% workspace.eff = length(workspace.stream) /length(workspace.Frame);
handels.hObject = plot(workspace.eff);
legend('Efficiency');
xlabel('X data size');
handels.output = hObject;
guidata(hObject, handles);
guidata(hObject,workspace);



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
workspace = guidata(hObject);
workspace.overhead= 1;
for i = 1:6
    if i ~= 0
        workspace.Stream = repmat(workspace.stream,1,i);
    else
        workspace.Stream = workspace.stream;
    end
    if workspace.type== 0 %UART
        workspace.Frame = UartFrameFormater(workspace.Stream,workspace.parity ...
            ,workspace.stopBits,workspace.numBits);
        %stream= workspace.Frame(:);
        
    elseif workspace.type== 1 %USB
        workspace.Frame = USBFrameFormater(workspace.Stream);
        workspace.Frame = bitStuff(workspace.Frame);
        [workspace.Dplus,workspace.Dminus]= DLinesGenerator(workspace.Frame);
        % stream = [workspace.Dplus(1:16) ; workspace.Dminus(1:16)]';
    else
        
    end
    workspace.overhead(i) =floor( 1-(length(workspace.Stream) /length(workspace.Frame(:))));
end
% workspace.eff = length(workspace.stream) /length(workspace.Frame);
handels.hObject = plot(workspace.overhead);
legend('%Overhead');
xlabel('X data size');
handels.output = hObject;
guidata(hObject, handles);
guidata(hObject,workspace);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
workspace = guidata(hObject);
workspace.time= 1;
for i = 1:6
    if i ~= 0
        workspace.Stream = repmat(workspace.stream,1,i);
    else
        workspace.Stream = workspace.stream;
    end
    if workspace.type== 0 %UART
        workspace.Frame = UartFrameFormater(workspace.Stream,workspace.parity ...
            ,workspace.stopBits,workspace.numBits);
        %stream= workspace.Frame(:);
        
    elseif workspace.type== 1 %USB
        workspace.Frame = USBFrameFormater(workspace.Stream);
        workspace.Frame = bitStuff(workspace.Frame);
        [workspace.Dplus,workspace.Dminus]= DLinesGenerator(workspace.Frame);
        % stream = [workspace.Dplus(1:16) ; workspace.Dminus(1:16)]';
    else
        
    end
    workspace.time(i) = length(workspace.Frame(:));
end
% workspace.eff = length(workspace.stream) /length(workspace.Frame);
handels.hObject = plot(workspace.time);
legend('Transmission Time');
xlabel('X data size');
ylabel('time');
handels.output = hObject;
guidata(hObject, handles);
guidata(hObject,workspace);


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
str = get(hObject , 'String');
val = get(hObject , 'Value');

workspace = guidata(hObject);
if val == 2
    workspace.parity = 0;
elseif val == 3
    workspace.parity = 1;
elseif val == 4
    workspace.parity = -1;
end

% switch str{val}
%     case {'even'}
%         workspace.partiy = 0 ;
%     case {'odd'}
%         workspace.partiy = 1 ;
%     case {'non'}
%         workspace.partiy = -1 ;
% end
guidata(hObject,workspace);
% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
workspace = guidata(hObject);
str = get(hObject , 'String');
val = get(hObject , 'Value');
switch str{val}
    case {'7-bits'}
        workspace.numBits = 7 ;
    case {'8-bits'}
        workspace.numBits = 8 ;
end
guidata(hObject,workspace);

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
workspace = guidata(hObject);
str = get(hObject , 'String');
val = get(hObject , 'Value');
switch str{val}
    case '1'
        workspace.stopBits = 1 ;
    case '2'
        workspace.stopBits = 2 ;
end
guidata(hObject,workspace);

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%data set
workspace = guidata(hObject);
fileID = fopen('inputdata.txt','r');
data = textscan(fileID,'%c');
fclose(fileID);
data = cell2mat(data);
p=dec2bin(double(data),8)';
x=fliplr(p);
out=x(:);
stream = str2num(out)';
workspace.stream = stream ;
guidata(hObject,workspace);
