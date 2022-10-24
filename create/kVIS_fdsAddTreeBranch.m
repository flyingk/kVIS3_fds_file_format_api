%
%> @file kVIS_fdsAddTreeBranch.m
%> @brief Add new branch to fdata tree. Branches have name and level only, no data
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
%> @brief Add new branch to fdata tree. Branches have name and level only, no data
%>
%> @param fds structure
%> @param Name of parent node
%> @param Name of new group
%>
%> @retval Modified fds structure
%> @retval New node index
%
function [ fds, node ] = kVIS_fdsAddTreeBranch(fds, parentGroup, newBranchName)
%
% get the column number of the tree parent
%
treeParentID = kVIS_fdsResolveGroupID(fds, parentGroup);

%
% Check if group exists
%
[~, node] = kVIS_fdsGetGroup(fds, newBranchName);

%
% create, if not
%
if node <= 0
    
    fds.fdata = [fds.fdata, cell(size(fds.fdata,1),1)];
    
    fds.fdata{fds.fdataRows.groupID, end}    = kVIS_fdsUniqueGroupID(fds);
    fds.fdata{fds.fdataRows.groupLabel, end} = newBranchName;
    fds.fdata{fds.fdataRows.treeParent, end} = treeParentID;
    fds.fdata{fds.fdataRows.treeGroupSelected, end} = false;
    fds.fdata{fds.fdataRows.treeGroupExpanded, end} = false;
    
    % number of this node
    node = size(fds.fdata, 2);
    
else
   
    % handle duplicated groups
    % need to ensure that full path is unique
    warning('kVIS_fdsAddTreeBranch::Group name exists, path unique??')
    
%     fds.fdata = [fds.fdata, cell(size(fds.fdata,1),1)];
%     
%     fds.fdata{fds.fdataRows.groupID, node}    = kVIS_fdsUniqueGroupID(fds);
%     fds.fdata{fds.fdataRows.groupLabel, node} = newBranchName;
%     fds.fdata{fds.fdataRows.treeParent, node} = treeParentID;
%     fds.fdata{fds.fdataRows.treeGroupSelected, node} = false;
%     fds.fdata{fds.fdataRows.treeGroupExpanded, node} = false;
    
end
    
end


