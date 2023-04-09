%
%> @file kVIS_fdsImportCSV.m
%> @brief Add data from a CSV file to the current data tree
%
%
% kVIS3 Data Visualisation
%
% Copyright (C) 2012 - present  Kai Lehmkuehler, Matt Anderson and
% contributors
%
% Contact: kvis3@uav-flightresearch.com
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%
%> @brief Add data from a CSV file to the current data tree
%>
%> @param Application handle structure
%>
%> @retval none
%
function kVIS_fdsImportCSV(hObject, ~)
%
% Import data from csv file 
%

fds = kVIS_fdsInitNew('Root');

[file, pathname] = uigetfile('*.csv');

if file==0
    return
end

InputFile = fullfile(pathname,file);

Tmp = fopen(InputFile);
ExportNames  = strsplit(fgetl(Tmp), ',');
fclose(Tmp);




T = readtable(InputFile);

T.Properties;

DataArray = table2array(T);

if iscell(DataArray)
    errordlg('Faulty FTI file - contains non-numerical data. Abort')
    fds = -1;
    return
end

%
% get new name (valid matlab var name required)
%
newName = {''};

while ~isvarname(newName{1})
    
    newName = inputdlg({'File Name','Tree root label'},'Select import names',1,{'CSV_Data','CSV_data'});
    
    % cancel
    if isempty(newName)
        return
    end
    
    % check name
    if ~isvarname(newName{1})
        he = errordlg('Not a valid Matlab variable name...');
        newName = {''};
        uiwait(gcf, 2)
        delete(he);
    end
    
    % check duplication
    str = sprintf('exist(''%s'', ''var'')', newName{1});
    
    if evalin('base',str)
        he = errordlg('Name exists...');
        newName = {''};
        uiwait(gcf, 2)
        delete(he);
    end
    
end
answ = newName;

fds = kVIS_fdsDataMatrix2Tree('DemoBSP', answ{2}, '.', ExportNames, DataArray, false);

kVIS_addDataSet(hObject, fds, answ{1})
end