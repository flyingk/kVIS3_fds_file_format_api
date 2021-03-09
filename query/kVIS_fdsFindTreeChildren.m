%
%> @file kVIS_fdsFindTreeChildren.m
%> @brief Find all descendants of the selected group
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
%> @brief Find all descendants of the selected group
%>
%> @param fds data structure
%> @param Group ID to use
%> @param Optional results array (used only for recursion, leave empty during fcn call)
%> @param Optional results array (used only for recursion, leave empty during fcn call)
%>
%> @retval Cell array with all children
%> @retval isLeaf flag (for recursions
%> @retval Array with all children column indices
%
function [Child, isLeaf, ChildIndex] = kVIS_fdsFindTreeChildren(fds, groupID, varargin)

if nargin == 2
    Child = '';
    ChildIndex = [];
else
    Child = varargin{1};
    ChildIndex = varargin{2};
end

% disp('exec==================================')

% find fds groups with groupID as a parent in their tree path (all descendants)
idx = strcmp(fds.fdata(fds.fdataRows.treeParent,:), groupID);

childrenIdx = find(idx==true);

if isempty(childrenIdx)
%     Child = Child;
    isLeaf = true;
    return
end

for I = 1:length(childrenIdx)
    
    ChildID = fds.fdata{fds.fdataRows.groupID, childrenIdx(I)};
    Child1  = fds.fdata(fds.fdataRows.groupLabel, childrenIdx(I));
    
    % any further descendants?
    tmpIdx = strcmp(fds.fdata(fds.fdataRows.treeParent,:), ChildID);
    isLeaf = ~any(tmpIdx);
    
    % need also the next level till we are on leaf level...
    if isLeaf == false
        [C,~,ChldIndex] = kVIS_fdsFindTreeChildren(fds, ChildID, Child1, childrenIdx(I));
        
        if isempty(Child)
            Child = C;
            ChildIndex = ChldIndex;
        else
            Child = [Child C];
            ChildIndex = [ChildIndex ChldIndex];
        end
        
    else
        if isempty(Child)
            Child = Child1;
            ChildIndex = childrenIdx(I);
        else
            Child = [Child Child1];
            ChildIndex = [ChildIndex childrenIdx(I)];
        end
    end
end

end