%
%> @file kVIS_fdsGetGroup.m
%> @brief Return data content of a tree group
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
%> @brief Return data content of a tree group
%>
%> @param fds data structure
%> @param Group identifier to search
%>
%> @retval Data content of group as array or -1 if not found
%> @retval fds.fdata column index of the group
%
function [data, index] = kVIS_fdsGetGroup(fds, groupName)

if ~isstruct(fds)
    warning('No fds structure specified...')
    data = -1;
    index = -1;
    return
end

try

[ID, Col] = kVIS_fdsResolveGroupID(fds, groupName);

catch ME
    warning(ME.message)
    data = -1;
    index = -1;
    return
end


data = fds.fdata{fds.fdataRows.data, Col};
index = Col;


end
