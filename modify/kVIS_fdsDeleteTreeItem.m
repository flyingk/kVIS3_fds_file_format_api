%
%> @file kVIS_fdsDeleteTreeItem.m
%> @brief Delete item from fds structure
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
%> @brief Delete item from fds structure
%>
%> @param fds data structure
%> @param Group ID to delete
%>
%> @retval Modified fds structure or -1 on user abort
%
function [fds] = kVIS_fdsDeleteTreeItem(fds, groupID)

% find fds cell column that corresponds to ID
[groupIdx] = kVIS_fdsGetGroupIDColumnIndex(fds, groupID);

% find all descendants
[childs, ~, idx] = kVIS_fdsFindTreeChildren(fds, groupID);

cols = size(fds.fdata,2);

rem = setdiff(1:cols, [groupIdx, idx]);

answer = questdlg(['Delete Group ' fds.fdata{fds.fdataRows.groupLabel, groupIdx} ' and all descendants ?'],...
    'Confirm delete','OK','Cancel','Cancel');

if strcmp(answer, 'OK')
    
    % set selected group to parent so tree stays open
    % TODO - tree does not use the data correctly
    parent = fds.fdata{fds.fdataRows.treeParent, groupIdx};
    [groupIdx] = kVIS_fdsGetGroupIDColumnIndex(fds, parent);
    fds.fdata{fds.fdataRows.treeGroupExpanded, groupIdx} = true;
    fds.fdata{fds.fdataRows.treeGroupSelected, groupIdx} = true;
    
    % remove group(s)
    fds.fdata = fds.fdata(:, rem);    
else
    
    fds = -1;

end



end

%% setdiff()