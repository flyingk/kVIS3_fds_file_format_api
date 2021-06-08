%
%> @file kVIS_fdsBuildTreePath.m
%> @brief Build the full tree path of a group
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
%> @brief Build the full tree path of a group
%>
%> @param fds data structure
%> @param Group ID to use
%>
%> @retval Full path as a string
%
function [treePath] = kVIS_fdsBuildTreePath(fds, groupID)

treePath = '';

while ischar(groupID)
    
    % find fds cell column that corresponds to ID
    [groupIdx] = kVIS_fdsGetGroupIDColumnIndex(fds, groupID);
    
    % ID of parent group
    groupID = fds.fdata{fds.fdataRows.treeParent, groupIdx};
    
    % Assemble path
    if isempty(treePath)
        treePath = [fds.fdata{fds.fdataRows.groupLabel, groupIdx}];
    else
        treePath = [fds.fdata{fds.fdataRows.groupLabel, groupIdx} '/' treePath];
    end
    
end

end