%
%> @file kVIS_fdsFindTreeChildren.m
%> @brief Find all children of the selected group
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
%> @brief Find all children of the selected group
%>
%> @param fds data structure
%> @param Group ID to use
%>
%> @retval Cell array with all children
%
function [Child, isLeaf] = kVIS_fdsFindTreeChildren(fds, groupID, Child)

% disp('exec==================================')

% find fds cell column that corresponds to ID
idx = strcmp(fds.fdata(fds.fdataRows.treeParent,:), groupID);

grp = find(idx==true);

if isempty(grp)
%     Child = Child;
    isLeaf = true;
    return
end

for I = 1:length(grp)
    
    ChildID = fds.fdata{fds.fdataRows.groupID, grp(I)};
    Child1   = fds.fdata(fds.fdataRows.groupLabel, grp(I));
    isLeaf  = ~isempty(fds.fdata{fds.fdataRows.data, grp(I)});
    
    % need also the next level till we are on leaf level...
    if isLeaf == false
        [C, isLeaf] = kVIS_fdsFindTreeChildren(fds, ChildID, Child1);
        
        if isempty(Child)
            Child = C;
        else
            Child = [Child C];
        end
        
    else
        if isempty(Child)
            Child = Child1;
        else
            Child = [Child Child1];
        end
    end
end

% Children
end