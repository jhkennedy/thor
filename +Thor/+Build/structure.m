function [f] =  structure
%%   structure is a gui used to build the initial structure for the Thor model. 
%
%
%
%

%% Initial conditions 
% load up default settings
evalin('base','load ./+Thor/+Build/Settings/DEFAULT.mat');
% initialize button check test array
cbtest = false(1,5);

%% initialize and hide the GUI as it is being created
f = figure('Visible','off','Position',[200,200,800,600]);

% Create use saved settings panel
HComp4 = uipanel('Title','Use a saved Settings Structure:','FontSize',16,...
                 'BackgroundColor', [1, 1, 1], 'Units', 'pixels',...
                 'Position', [10, 490, 780, 100]);

% create  make setting  panel
HComp5 = uipanel('Title','Create a Settings Structure:','FontSize',16,...
                 'BackgroundColor', [1, 1, 1], 'Units', 'pixels',...
                 'Position', [10, 10, 780, 470]);
             
% create Model-wide Components panel
HComp3 = uipanel('Title', 'Model-wide Components','FontSize',12,...
                 'BackgroundColor', [0.7, 0.7, 0.7], 'Units', 'pixels',...
                 'Position', [20, 90, 430, 85]);

% create Element-wide Components panel
HComp2 = uipanel('Title', 'Element-wide Components','FontSize',12,...
                 'BackgroundColor', [0.7, 0.7, 0.7], 'Units', 'pixels',...
                 'Position', [20, 160, 430, 200]);
             
% create Crystal Distrobution Components panel
HComp1 = uipanel('Title', 'Crystal Distrobution Components','FontSize',12,...
                 'BackgroundColor', [0.7, 0.7, 0.7], 'Units', 'pixels',...
                 'Position', [20, 345, 430, 105]);
             
%% Creat the explination
Hexpl = uicontrol('Style', 'edit','HorizontalAlignment','left','Max',2,'Min',0,...
                  'String',{...
'In the Crystal Distrobution Components: Select the Crystal Distrobution Components you desire for your model.',...
' ',...
'In the Element-wide Components: Enter the number of elements to create for your model. Edit the inbuild structure feilds: disangles, glenexp, stress, grain, and T. Once a feild is set how you want it, check the check-box for the corrosponding variable. You will not be able to build the initial setting structure until they are all checked.',...
' ',...
'    Distrobution Angle Variable (inbuild.disangles): #ELEMENTSx2 array holding [Ao1, A1; ...; Ao_NELEM, A_NELEM] where the `Ao`s are the girdle angle of the crystal distrobution and the `A`s are the cone angles of the distrobution.',...
' ',...
'    Glen Exponent Variable (inbuild.glenexp): #ELEMENTSx1 array holding the exponent from glens flow law for each element. 3 is generaly used for all elements.',...
' ',...
'     Stress Tensor Variable (inbuild.stress): 3x3x#ELEMENTS array holding the stress tensor for each element.',...
' ',...
'     Max/Min Grain Size Variable (inbuild.grain): #ELEMENTSx2 array holding, [MIN, MAX], the minimum, MIN, and maximum, MAX, crystal diameters for building a crystal distrobution. Grain sizes are picked randomly from within this open interval.',...
' ',...
'     Tempurature variable(inbuild.T): #ELEMENTSx1 array holding the temperature of each element.',...
' ',...
'In the model-wide Components: Turn on or off Nearest Neigbor Interaction (NNI) then enter the strength of the neighboring crystal relative to the center crystal. Next, Enter then time step size and select the appropriate units.'},...
                  'Position',[450,90,330,350]);%#ok<NASGU>
             
%% Construct the Crystal Distrobution components

    % Number of crystals
    Hnumbcrys    = uicontrol(HComp1,'Style','popupmenu','Value',9,...
                             'String',{'125','216','512','1000','1728',...
                                       '2744','4096','5832','8000','10648','15625'},...
                             'Units','Normalized','Position',[.1,.25,.2,.3]);
         Htext1  = uicontrol(HComp1,'Style','text','String',...
                             'Number of Crystals',...
                             'Units','Normalized','Position',[.1,.6,.2,.35]); %#ok<NASGU>
        set(Hnumbcrys, 'Callback',@CBHnumbcrys);
        function CBHnumbcrys(HObject, eventdata) %#ok<*INUSD>
            val1 = get(HObject,'Value');
            list1 = get(HObject,'String');
            numbcrys = str2double(list1{val1});
            width = numbcrys^(1/3);
            evalin('base', ['default.numbcrys = ', int2str(numbcrys),';']);
            evalin('base', ['default.width = ', int2str(width),';']);
        end
                

    % Conectivity structure type                     
    Hcontype    = uicontrol(HComp1,'Style', 'popupmenu','Value',1,...
                            'String', {'Cubic'},... ,'Hexagonal'
                            'Units','Normalized','Position',[.4,.25,.2,.3]);
         Htext2  = uicontrol(HComp1,'Style','text','String',...
                             'Conectivity Structure',...
                             'Units','Normalized','Position',[.4,.6,.2,.35]); %#ok<NASGU>
        set(Hcontype, 'Callback',@CBHcontype);
        function CBHcontype(HObject, eventdata) 
            val2 = get(HObject,'Value');
            list2 = get(HObject,'String');
            switch list2{val2}
                case list2{1}
                    contype = 'cubic';
               % case list2{2}
               %     contype = 'hex';
            end
            evalin('base', ['default.contype = ''', contype,''';']);
        end
    
    % Distrobution type
    Hdistype    = uicontrol(HComp1,'Style', 'popupmenu','Value',1,...
                            'String', {'Isotropic'},...
                            'Units','Normalized','Position',[.7,.25,.2,.3]);
         Htext3  = uicontrol(HComp1,'Style','text','String',...
                             'Distrobution Type',...
                             'Units','Normalized','Position',[.7,.6,.2,.35]);%#ok<NASGU>
        set(Hdistype, 'Callback',@CBHdistype);
        function CBHdistype(HObject, eventdata) 
            val3 = get(HObject,'Value');
            list3 = get(HObject,'String');
            switch list3{val3}
                case list3{1}
                    distype = 'iso';
            end
            evalin('base', ['default.distype = ''', distype,''';']);
        end


%% Construct the Element wide components

    % Number of elements
    Hnelem       = uicontrol(HComp2,'Style', 'edit','String','1',...
                            'Units', 'Normalized','Position', [.075,.6,.15,.15]);
         Htext5  = uicontrol(HComp2,'Style','text','String',...
                             'Number of Elements',...
                             'Units', 'Normalized','Position',[.025,.75,.25,.2]);%#ok<NASGU>
        set(Hnelem, 'Callback',@CBHnelem);
        function CBHnelem(HObject, eventdata) 
            str5 = get(HObject,'String');
            nelem = str2double(str5);
            evalin('base', ['default.nelem = ', int2str(nelem),';']);
        end
    
    % Distrobution angles CB1
    Hconangle    = uicontrol(HComp2,'Style', 'checkbox',...
                            'Units', 'Normalized','Position',[.45,.575,.05,.2]);
         Htext4  = uicontrol(HComp2,'Style','text','String',...
                             'Distrobution Angle Variable',...
                             'Units', 'Normalized','Position',[.3,.75,.35,.2]);%#ok<NASGU>
        set(Hconangle, 'Callback',@CBHconangle);
        function CBHconangle(HObject, eventdata)
            if (get(HObject,'Value') == get(HObject,'Max'))
                % Checkbox is checked-take approriate action
                cbtest(1) = 1;
            else
                % Checkbox is not checked-take approriate action
                cbtest(1) = 0;
            end
        end
        
    % Glen Exponent CB2
    Hglenexp     = uicontrol(HComp2,'Style', 'checkbox',...
                            'Units', 'Normalized','Position',[.775,.575,.05,.2]);
         Htext6  = uicontrol(HComp2,'Style','text','String',...
                             'Glen Exponent Variable',...
                             'Units', 'Normalized','Position',[.675,.75,.25,.2]);%#ok<NASGU>
        set(Hglenexp, 'Callback',@CBHglenexp);
        function CBHglenexp(HObject, eventdata)
            if (get(HObject,'Value') == get(HObject,'Max'))
                % Checkbox is checked-take approriate action
                cbtest(2) = 1;
            else
                % Checkbox is not checked-take approriate action
                cbtest(2) = 0;
            end
        end
    % Stress tensors CB3
    Hstress      = uicontrol(HComp2,'Style', 'checkbox',...
                            'Units', 'Normalized','Position',[.125,.075,.05,.2]);
         Htext7  = uicontrol(HComp2,'Style','text','String',...
                             'Stress Tensor Variable',...
                             'Units', 'Normalized','Position',[.005,.25,.3,.2]);%#ok<NASGU>
        set(Hstress, 'Callback',@CBHstress);
        function CBHstress(HObject, eventdata)
            if (get(HObject,'Value') == get(HObject,'Max'))
                % Checkbox is checked-take approriate action
                cbtest(3) = 1;
            else
                % Checkbox is not checked-take approriate action
                cbtest(3) = 0;
            end
        end
    % Grain size (min, max) CB4
    Hgrain       = uicontrol(HComp2,'Style', 'checkbox',...
                            'Units', 'Normalized','Position',[.45,.075,.05,.2]);
         Htext8  = uicontrol(HComp2,'Style','text','String',...
                             'Max/Min Grain Size Variable',...
                             'Units', 'Normalized','Position',[.3,.25,.35,.2]);%#ok<NASGU>
        set(Hgrain, 'Callback',@CBHgrain);
        function CBHgrain(HObject, eventdata)
            if (get(HObject,'Value') == get(HObject,'Max'))
                % Checkbox is checked-take approriate action
                cbtest(4) = 1;
            else
                % Checkbox is not checked-take approriate action
                cbtest(4) = 0;
            end
        end
    
    % Temperature Variable Name CB5
    HT      = uicontrol(HComp2,'Style', 'checkbox',...
                            'Units', 'Normalized','Position',[.775,.075,.05,.2]);
         Htext11  = uicontrol(HComp2,'Style','text','String',...
                             'Tempurature (Celsius) Variable',...
                             'Units', 'Normalized','Position',[.65,.25,.3,.2]);%#ok<NASGU>
        set(HT, 'Callback',@CBHT);
        function CBHT(HObject, eventdata)
            if (get(HObject,'Value') == get(HObject,'Max'))
                % Checkbox is checked-take approriate action
                cbtest(5) = 1;
            else
                % Checkbox is not checked-take approriate action
                cbtest(5) = 0;
            end
        end                         

                         
%% Construct the model wide components 
    % On Off Nearest Neigbor Interaction
    Hynsoft     = uicontrol(HComp3,'Style', 'checkbox', 'Value',1,...
                            'Units', 'Normalized','Position',[.05,.25,.05,.2]);
         Htext12  = uicontrol(HComp3,'Style','text','String',...
                             'NNI',...
                             'Units', 'Normalized','Position',[.025,.65,.1,.2]);%#ok<NASGU>
        set(Hynsoft, 'Callback',@CBHynsoft);
        function CBHynsoft(HObject, eventdata)
            if (get(HObject,'Value') == get(HObject,'Max'))
                % Checkbox is checked-take approriate action
                evalin('base','default.ynsoft = ''yes'';');
            else
                % Checkbox is not checked-take approriate action
                evalin('base','default.ynsoft = ''no'';');
            end
        end
    
    % Softness parameter
    Hsoft       = uicontrol(HComp3,'Style', 'edit','String','0',...
                            'Units', 'Normalized','Position',[.15,.15,.15,.4]);
         Htext13  = uicontrol(HComp3,'Style','text','String',...
                             'NNI Size',...
                             'Units', 'Normalized','Position',[.15,.65,.15,.2]);%#ok<NASGU>
        set(Hsoft, 'Callback',@CBHsoft);
        function CBHsoft(HObject, eventdata) 
            str13 = get(HObject,'String');
            evalin('base', ['default.soft = [1,',str13,'];']);
        end
    
    % Time Step Size
    Htsize    = uicontrol(HComp3,'Style', 'edit','String','3.1557e9',...
                            'Units', 'Normalized','Position',[.4,.15,.25,.4]);
         Htext9  = uicontrol(HComp3,'Style','text','String',...
                             'Time Step Size',...
                             'Units', 'Normalized','Position',[.4,.65,.25,.2]);%#ok<NASGU>
        set(Htsize, 'Callback',@CBHtsize);
        function CBHtsize(HObject, eventdata) 
            str9 = get(HObject,'String');
            tsize = str2double(str9);
            evalin('base', ['default.tsize = ', num2str(tsize, '%10.5e'),';']);
        end
                         
    % Time Step Units
    Htunit     = uicontrol(HComp3,'Style','popupmenu','Value',1,...
                            'String', {'Seconds','Days', 'Weeks', 'Years'},...
                            'Units', 'Normalized','Position',[.7,.15,.25,.4]);
         Htext10  = uicontrol(HComp3,'Style','text','String',...
                             'Time Step Units',...
                             'Units', 'Normalized','Position',[.7,.65,.25,.2]);%#ok<NASGU>
        set(Htunit, 'Callback',@CBHtunit);
        function CBHtunit(HObject, eventdata) 
            val10 = get(HObject,'Value');
            list10 = get(HObject,'String');
            tunit = list10{val10};
            evalin('base', ['default.tunit = ''', tunit,''';']);
        end

%% Construct the saved settings components
    svdset = what('+Thor/+Build/Settings/');
    SVD = svdset.mat{1};
    Hsvd     = uicontrol(HComp4,'Style','popupmenu','Value',1,...
                            'BackgroundColor', [.9, .9, .9],'String', svdset.mat,...
                            'Units', 'Normalized','Position',[.05,.15,.4,.4]);
         Htext20  = uicontrol(HComp4,'Style','text','String',...
                             'Saved Settings Structures','BackgroundColor', [1, 1, 1],...
                             'Units', 'Normalized','Position',[.05,.65,.4,.2]);%#ok<NASGU>
         set(Hsvd,'Callback', @CBHsvd);
         function CBHsvd(HObject, eventdata)
             val30 = get(HObject,'Value');
             list30 = get(HObject,'String');
             SVD = list30{val30};
         end   
     
    Hrefresh     = uicontrol(HComp4,'Style','pushbutton',...
                            'BackgroundColor', [.9, .9, .9],'String', 'Refresh List',...
                            'Units', 'Normalized','Position',[.5,.25,.15,.5]);
         set(Hrefresh,'Callback', @CBHrefresh);
         function CBHrefresh(HObject, eventdata)
            svdset = what('./+Thor/+Build/Settings/');
            set(Hsvd, 'String',svdset.mat);
         end   
     Hset1     = uicontrol(HComp4,'Style','pushbutton',...
                            'BackgroundColor', [.9, .9, .9],'String', 'Set and Close',...
                            'Units', 'Normalized','Position',[.7,.25,.25,.5]);
         set(Hset1,'Callback', @CBHset1);
         function CBHset1(HObject, eventdata)
             evalin('base', ['load ./+Thor/+Build/Settings/',SVD]);
             evalin('base', 'in = default;');
             evalin('base','save ./+Thor/+Build/initial.mat in');
             evalin('base','clear default in');
             delete(f);
         end   
     
%% Construct the create settings components
    ssname ='.mat';
    Hcrt    = uicontrol(HComp5,'Style','edit',...
                            'BackgroundColor', [.9, .9, .9],'String', '.mat',...
                            'Units', 'Normalized','Position',[.05,.03,.4,.05]);
         Htext20  = uicontrol(HComp5,'Style','text','String',...
                             'Settings Structure Name','BackgroundColor', [1, 1, 1],...
                             'Units', 'Normalized','Position',[.05,.08,.4,.05]);%#ok<NASGU>
         set(Hcrt,'Callback', @CBHcrt);
         function CBHcrt(HObject, eventdata)
             ssname = get(HObject,'String');
             sstest = strfind(ssname, '.mat');
             if isempty(sstest)
                 ssname = [ssname,'.mat'];
             end
         end   
    Hsave     = uicontrol(HComp5,'Style','pushbutton',...
                            'BackgroundColor', [.9, .9, .9],'String', 'Save',...
                            'Units', 'Normalized','Position',[.5,.03,.15,.1]);
         set(Hsave,'Callback', @CBHsave);
         function CBHsave(HObject, eventdata)
             if sum(cbtest) == 5;
                evalin('base', '[default.tsize, default.tunit] = Thor.Utilities.tempUnitSwitch(default.tsize, default.tunit);');
                evalin('base', 'default.Do = mean(default.grain,2);');
                evalin('base', ['save ./+Thor/+Build/Settings/',ssname,' default']);
             else
                 errordlg('Not all the variable boxes are checked, make sure you have created the variables.','Error Saving  Structure','modal');
             end
         end  
     Hset2     = uicontrol(HComp5,'Style','pushbutton',...
                            'BackgroundColor', [.9, .9, .9],'String', 'Save, Set and Close',...
                            'Units', 'Normalized','Position',[.7,.03,.25,.1]);
         set(Hset2,'Callback', @CBHset2);
         function CBHset2(HObject, eventdata)
             if sum(cbtest) == 5;
                evalin('base', '[default.tsize, default.tunit] = Thor.Utilities.tempUnitSwitch(default.tsize, default.tunit);');
                evalin('base', 'default.Do = mean(default.grain,2);');
                evalin('base', ['save ./+Thor/+Build/Settings/',ssname,' default']);
             else
                 errordlg('Not all the variable boxes are checked, make sure you have created the variables.','Error Saving  Structure','modal');
             end
             evalin('base', 'in = default;');
             evalin('base','save ./+Thor/+Build/initial.mat in');
             evalin('base','clear default in');
             close(f);
         end 

%% Turn on GUI for use
set(f,'Visible','on')




end