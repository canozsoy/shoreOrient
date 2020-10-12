%{

This code calculates shore orientation angle with respect to positive
x-axis.

Input file should be exported as txt from surfer. Inputs section should be
filled accordingly. There are comments next to inputs command lines. 

C. �zsoy (2020)

%}

clc
clear
close all

%% Inputs

shoreFileName='shore.txt';                                                  % Enter filename that contains x,y,z of shoreline
language=1;                                                                 % Enter language (1):English, (2): Turkish
startX=3.900183931802643e+05;                                               % Enter lowest X of area of interest
endX=3.904306790246720e+05;                                                 % Enter highest X of area of interest 
startY=4.052714359426968e+06;                                               % Enter lowest Y of area of interest
endY=4.053144065800013e+06;                                                 % Enter highest Y of area of interest

%% Main Code

shoreLine=dlmread(shoreFileName);
shoreLineOrg=shoreLine;
ind=find(shoreLine(:,1)<=startX | shoreLine(:,1)>=endX |...
    shoreLine(:,2)<=startY | shoreLine(:,2)>=endY);
shoreLine(ind,:)=[];
[A,B,R]=postreg(shoreLine(:,2),shoreLine(:,1),'hide');
figure('windowstate','maximized');
scatter(shoreLineOrg(:,1),shoreLineOrg(:,2));
hold on;
plot(shoreLine(:,1),A*shoreLine(:,1)+B,'k','LineWidth',3);
scatter(shoreLine(:,1),shoreLine(:,2));
pr=gca;
grid on;
if language==1
    legend('Original Zero Points','Regression Line','Area of Interest');
    xlabel('Longitude (m)');
    ylabel('Latitude (m)');
    title('For checking');
elseif language==2
    legend('Orjinal S�f�r Noktalar�','Ba�lan�m �izgisi','�lgi Alan�');
    xlabel('Boylam (m)');
    ylabel('Enlem (m)');
    title('Kontrol i�in');
end
pr.FontName='Calibri';
pr.FontSize=14;
xTicks=ThousandSep(xticks,'%.16g',',');
yTicks=ThousandSep(yticks,'%.16g',',');
xticklabels(xTicks);
yticklabels(yTicks);
axis equal;
hold off;
Degree=rad2deg(atan(A));
fprintf('Shoreline orientation is %.2f degrees.\n',Degree);

function S = ThousandSep(N, FSpec, Sep)
% ThousandSep - Number as string with separators every 3rd digit
% S = ThousandSep(N, FSpec, Sep)
% INPUT:
%   N:     Numbers, all classes accepted by SPRINTF, scalar or array.
%   FSpec: Format specifier for SPRINTF. Optional, default: '%.16g'
%   Sep:   Character as separator. Optional, default: ,
% OUTPUT:
%   S:     String if N is a scalar, otherwise a cell string.
%
% EXAMPLES:
%   ThousandSep(1234567.2345)         % '1,234,567.2345'
%   ThousandSep(1234, char(39))       % '1'234'
%   ThousandSep([2.3, 1234], ' ')     % {'2.3', '1 234'}
%   ThousandSep(-1234, '%9.1f', ',')  % '  -1,234.0'
%
% NOTES:
% * The default Sep and FSpec can be adjusted on top of the code.
% * Alternative java call, which is about 20% slower (Matlab R2011b/64/Win7):
%     nf = java.text.DecimalFormat;
%     S  = nf.format(1234567.890123)
% * Matlab 6: The subfunction ToString must be modified to run under Matlab 6.
%   See the comments there.
% * Run the unit-test uTest_ThousandSep to check validity and speed.
%
% Tested: Matlab 7.7, 7.8, 7.13, WinXP/32, Win7/64
% Author: Jan Simon, Heidelberg, (C) 2015 matlab.2010(a)n(MINUS)simon.de
%
% See also FORMAT, SPRINTF.

% $JRev: R-c V:002 Sum:S7fqIWe3LFOL Date:24-May-2015 19:11:36 $
% $License: BSD (use/copy/change/redistribute on own risk, mention the author) $
% $UnitTest: uTest_ThousandSep $
% $File: Tools\GLString\ThousandSep.m $

% Initialize: ==================================================================
% Change this to your preferred defaults:
defaultSep   = ',';       % CHAR(39) is less confusing than: ''''
defaultFSpec = '%.16g';

% Check inputs: ----------------------------------------------------------------
switch nargin
   case 1
      FSpec = defaultFSpec;
      Sep   = defaultSep;
   case 2
      if strncmp(FSpec, '%', 1)
         Sep   = defaultSep;
      else
         Sep   = FSpec;
         FSpec = defaultFSpec;
      end
   case 3
      if ~ischar(Sep) || length(Sep) ~= 1
         error(['JSimon:', mfilename, ':BadSep'], ...
            '3rd input Sep must be a character.');
      end
   otherwise
      error(['JSimon:', mfilename, ':BadNinput'], '1 to 3 inputs needed.');
end

if ~isnumeric(N)
   error(['JSimon:', mfilename, ':BadClassN'], '1st input N must by numeric.');
end

% Do the work: =================================================================
if numel(N) == 1  % N is a scalar:
   S = ToString(N, FSpec, Sep);
else              % N is an array:
   S = cell(size(N));
   for k = 1:numel(N)
      S{k} = ToString(N(k), FSpec, Sep);
   end
end
end

% return;

% ==============================================================================
function S = ToString(N, FSpec, Sep)

S   = sprintf(FSpec, N);
Fin = strfind(S, '.');
if isempty(Fin)
   Fin = length(S) + 1;
end

% Matlab 7:
Ini = find(isstrprop(S, 'digit'), 1);
% Matlab 6:
% Ini = find(S >= '0' & S <= '9');
% Ini = Ini(1);

S(2, Fin - 4:-3:Ini) = Sep;
S = S(S ~= char(0)).';

% return;
% EOF
end
