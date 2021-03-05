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
function [fds] = kVIS_fdsDeleteTreeItem(fds, itemID)

% find fds cell column that corresponds to ID
idx = strcmp(fds.fdata(fds.fdataRows.groupID,:), itemID);

grp = find(idx==true)

answer = questdlg(['Delete Group ' fds.fdata{fds.fdataRows.groupLabel,grp} ' ?'],'Confirm delete','OK','Cancel','Cancel');

if strcmp(answer, 'OK')
    
    % remove group
    fds.fdata = fds.fdata(:,[1:grp-1, grp+1:end]);
    
    % need to remove children if item is a branch
    % TODO
    
    % set selected group to parent so tree stays open
    % TODO
    
else
    
    fds = -1;

end



end

