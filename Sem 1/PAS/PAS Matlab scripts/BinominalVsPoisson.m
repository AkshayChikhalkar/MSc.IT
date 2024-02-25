function varargout = BinominalVsPoisson(varargin)
% BINOMINALVSPOISSON MATLAB code for BinominalVsPoisson.fig
%      BINOMINALVSPOISSON, by itself, creates a new BINOMINALVSPOISSON or raises the existing
%      singleton*.
%
%      H = BINOMINALVSPOISSON returns the handle to a new BINOMINALVSPOISSON or the handle to
%      the existing singleton*.
%
%      BINOMINALVSPOISSON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BINOMINALVSPOISSON.M with the given input arguments.
%
%      BINOMINALVSPOISSON('Property','Value',...) creates a new BINOMINALVSPOISSON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BinominalVsPoisson_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BinominalVsPoisson_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BinominalVsPoisson

% Last Modified by GUIDE v2.5 14-Nov-2015 17:25:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BinominalVsPoisson_OpeningFcn, ...
                   'gui_OutputFcn',  @BinominalVsPoisson_OutputFcn, ...
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


% --- Executes just before BinominalVsPoisson is made visible.
function BinominalVsPoisson_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BinominalVsPoisson (see VARARGIN)

% Choose default command line output for BinominalVsPoisson
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BinominalVsPoisson wait for user response (see UIRESUME)
% uiwait(handles.figure1);

myOpeningFcn(hObject, handles)


% --- Outputs from this function are returned to the command line.
function varargout = BinominalVsPoisson_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_n_Callback(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_n as text
%        str2double(get(hObject,'String')) returns contents of edit_n as a double

myGetStringValue(hObject,'n');


% --- Executes during object creation, after setting all properties.
function edit_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_p_Callback(hObject, eventdata, handles)
% hObject    handle to edit_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_p as text
%        str2double(get(hObject,'String')) returns contents of edit_p as a double

myGetStringValue(hObject,'p');

% --- Executes during object creation, after setting all properties.
function edit_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
% ------------------------------------------------------------------------
% The code above was generated automatically.
% Only the function calls of myOpeningFcn and myGetStringValue were added.
%
% The code below was generated manually.
% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
function myOpeningFcn(hObject, handles)
handles.axes1 = findobj(gcf,'Tag','axes1');
handles.precision = 5;
handles.n = 1000;
handles.p = 0.3;

guidata(hObject, handles);
paint(handles);

% ------------------------------------------------------------------------
function myGetStringValue(hObject,val)
handles = guidata(gcbo);
user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('Ungültige Eingabe','Bad Input','modal');
    uiwait;
else
    eval(['handles.' val '=' get(hObject,'string') ';']);
    guidata(gcbo,handles);
end
paint(handles);

% ------------------------------------------------------------------------
function paint(handles)
handles.n = round(handles.n);
handles.n = syncronizeValue(handles,'n');
n = handles.n;

if handles.p > 1
    handles.p = 1;
elseif handles.p < 0
    handles.p = 0;
end
handles.p = syncronizeValue(handles,'p');
p = handles.p;

m = n*p; % = lambda
sigma_poiss = sqrt(m);

% pmf's are calculated for the interval
%  [m - k*sigma, m + k*sigma]
k = 3;
n1 = max(0, floor(m - k*sigma_poiss));
n2 = min(n, ceil(m + k*sigma_poiss));
x = n1:n2;

str_title = 'Binomial and Poisson pmf''s';
str_pmf_bino_paras = ['Binomial(' num2str(n) ',' num2str(p) ')'];
str_pmf_poiss_paras = ['Poisson(' num2str(m) ')'];

pmf_bino = binopdf(x,n,p);
sigma_bino = sigma_poiss*sqrt(1-p);

pmf_poiss = poisspdf(x,m);

axes(handles.axes1);
hold off
h1 = plot(x,pmf_bino,'b.');
hold on
h4 = plot(x,pmf_poiss,'m.');

a = axis();
a(1) = n1;
a(2) = n2;
a(4) = max(pmf_bino)*1.1;
%hold on

% plot of expectation
lw = 2;
h2 = plot([m, m], [a(3), a(4)], 'g:','Linewidth',lw);
axis(a);

% plot of standard deviations from expectation
h3 = plot([m-sigma_bino, m-sigma_bino], [a(3), a(4)], 'b:','Linewidth',lw);
plot([m+sigma_bino, m+sigma_bino], [a(3), a(4)], 'b:','Linewidth',lw)

h5 = plot([m-sigma_poiss, m-sigma_poiss], [a(3), a(4)], 'm:','Linewidth',lw);
plot([m+sigma_poiss, m+sigma_poiss], [a(3), a(4)], 'm:','Linewidth',lw)

grid on
lStr1 = ['\it ' str_pmf_bino_paras];
lStr2 = ['\it expectation m = ', num2str(m)];
lStr3 = ['\it m \pm \sigma = m \pm ', num2str(sigma_bino)];
lStr4 = ['\it ' str_pmf_poiss_paras];
lStr5 = ['\it m \pm \sigma = m \pm ', num2str(sigma_poiss)];
legend([h1 h2 h3 h4 h5], lStr1, lStr2, lStr3, lStr4, lStr5);
title(str_title);
xlabel('i \rightarrow');
ylabel('Pr(X=i) \rightarrow');

%delta_rel_sum = sum(abs(binopdf(0:n,n,p)-poisspdf(0:n,m)))
delta_rel_atMean = max(abs(binopdf(round(m),n,p)-poisspdf(round(m),m))/binopdf(round(m),n,p))
delta_max_rel_3sigma = max(abs(binopdf(x,n,p)-poisspdf(x,m))./binopdf(x,n,p))


% ------------------------------------------------------------------------
function value = syncronizeValue(handles, valueName)
[value, value_str] = round2stringrep(eval(['handles.' valueName]),handles.precision);
eval(['handles.' valueName '=value;']);
set(eval(['handles.edit_' valueName]),'String',value_str);

% ------------------------------------------------------------------------
function [roundedNumber, roundedNumber_str] = round2stringrep(value,precision)
roundedNumber_str = num2str(value,['%11.' num2str(precision) 'g']);
roundedNumber = str2double(roundedNumber_str);
