% Berechnung von Redundanten Wavelet auf Basis der Wavelet-Toolbox
%
%
% Notwendigen Matlab-Toolboxen:
%       Wavelet-Toolbox
%
%
% Notwendigen m-Files:
%       Keine zusaetzliche m-Files notwendig.
%
% #########################################################################
%
% $Function call:   [out] = red_wt(matrix, d, it, vonbis)
%
% $Description:
%       Die Berechnung basiert auf der Funktion swt2 aus der
%       Wavelet-Tolbox. Im Gegensatz zum Toolbox, wird das Ergebnis nicht
%       alle Skalen auf einmal geliefert, sondern nur von der benötigten
%       Skala. Dadurch wird die Ausgabe von B^(n+1) auf B^2 reduziert wobei
%       B=Bildfläche ist.
%
%
% $in-Parameter:
%       matrix: double-Array
%               Eingangsmatrix
%
%       d:      String
%               Transformationsart (z.B.: 'haar', 'db2', 'db3' usw.). Für
%               mehr Details siehe Wavelettoolbox (default: 'haar').
%
%       it:     Integer
%               Iterationsanzahl (default: 1)
%
%       vonbis: Integer
%               Auswahlmöglichkeit, ob die Transformationsergebnisse über
%               alles Skalen berechnet werden (vonbis = 0) oder nur von
%               der letze Skala (vonbis = 1).
%               (default: 0 (von 1 bis x)).
%
%
% $out-Parameter:
%       out:    Ausgangsmatrix.
%
%
% #########################################################################
% $Author:           Eugen Gillich
% $Date:             2007-11-28
% -------------------------------------------------------------------------
%
% Modifikationen:
%
% $Revision:         0.3
% $Date:             2008-07-22
% $Author:           Eugen Gillich
% $                  Der Filter wird ab Skala zwei mit Nullen gespreizt.
%
%
% $Revision:         0.2
% $Date:             2007-11-28
% $Author:           Eugen Gillich
%


%% Initialisierung
function [out] = red_wt(varargin)

vrg = length(varargin);
matrix = varargin{1};
% Transformationsart
if vrg > 1
    d = varargin{2};
else
    d = 'haar';
end;
% Skala
if vrg > 2
    it = varargin{3};    
else
    it = 1;    
end;
% Ausgabe von Skalla 1 bis x
if vrg > 3
    vonbis = varargin{4};    
else
    vonbis = 0;
end;
% % Die Filter werden ausgelesen (für biortogonale Filter)
% [t,h]=wfilters(d,'r');

% Die Filter werden ausgelesen
[t,h]=wfilters(d,'d');
%% Transformation
if vonbis == 1
    for it_i=1:it        
        if it_i == 1	% Erste Iteration     
            [cA,cH,cV,cD]=(swt2(double(matrix), double(1),t,h));           
        else            % ab 2. Iteration        
            % 2008-07-22 -->
%             t=upsample(t,2); %Filter wird upgesampelt mit Nullen.
%             h=upsample(h,2); %Filter wird upgesampelt mit Nullen.
            % <-- 2008-07-22
            [cA,cH,cV,cD]=(swt2(double(cA), double(1), t, h));  
        end;
    end;
else
    % Unveränderte swt2-Transformation aus Wavelet-Toolbox (vonbis = 0)
    [cA,cH,cV,cD]=(swt2(double(matrix), double(it),t,h));
end;
% Ausgabevariable wird gebildet
out{1}=cA; out{2}=cH; out{3}=cV; out{4}=cD;
