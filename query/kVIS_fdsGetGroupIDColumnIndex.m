%
%> @file kVIS_fdsGetGroupIDColumnIndex.m
%> @brief Find the column number for a group ID in the fds.fdata array
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
%> @brief Find the column number for a group ID in the fds.fdata array
%>
%> @param fds data structure
%> @param Group ID to use
%>
%> @retval Group column number, -1 if group does not exist
%
function [groupIdx] = kVIS_fdsGetGroupIDColumnIndex(fds, groupID)

% there are 0 or 1 matching groups (unique identifier)
idx = strcmp(fds.fdata(fds.fdataRows.groupID,:), groupID);

if any(idx)
    groupIdx = find(idx==true);
else
    groupIdx = -1;
end

end