%
%> @file kVIS_fdsUpgrade2V2_0.m
%> @brief Upgrade a fds 1.0 to 2.0
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
%> @brief Upgrade a fds 1.0 to 2.0
%>
%> @param fds 1.0 data structure
%>
%> @retval fds 2.0 data structure
%
function fds2 = kVIS_fdsUpgrade2V2_0(fds1)

fds2 = kVIS_fdsInitNew();

% size of old array
cols = fds1.fdataAttributes.nFiles;

% copy content into new structure - don't assume any row content...
fds2.fdata(fds2.fdataRows.groupLabel,1:cols) = fds1.fdata(fds1.fdataRows.groupLabel,:);

fds2.fdata(fds2.fdataRows.varNames,:)     = fds1.fdata(fds1.fdataRows.varNames,:);
fds2.fdata(fds2.fdataRows.varUnits,:)     = fds1.fdata(fds1.fdataRows.varUnits,:);
fds2.fdata(fds2.fdataRows.varFrames,:)    = fds1.fdata(fds1.fdataRows.varFrames,:);
fds2.fdata(fds2.fdataRows.varNamesDisp,:) = fds1.fdata(fds1.fdataRows.varNamesDisp,:);
% fds2.fdata(fds2.fdataRows.dataSource,:)   = fds1.fdata(fds1.fdataRows.dataSource,:);
fds2.fdata(fds2.fdataRows.data,:)         = fds1.fdata(fds1.fdataRows.data,:);

% fds2.fdata(fds2.fdataRows.treeParent,:) = fds1.fdata(fds1.fdataRows.treeParent,:);
fds2.fdata(fds2.fdataRows.treeGroupExpanded,:) = {false};
fds2.fdata(fds2.fdataRows.treeGroupSelected,:) = {false};

% add groupID
for I = 1:cols
    fds2.fdata{fds2.fdataRows.groupID, I} = kVIS_fdsUniqueGroupID();
end

% update treeParent

% root
fds2.fdata{fds2.fdataRows.treeParent, 1} = 0;

% rest - fds 1.0 is always in order
for I = 2:cols
    p = fds1.fdata{fds1.fdataRows.treeParent, I};
    fds2.fdata{fds2.fdataRows.treeParent, I} = fds2.fdata{fds2.fdataRows.groupID, p};
end

fds2 = kVIS_fdsUpdateAttributes(fds2);

% other containers
fds2.eventList    = fds1.eventList;
fds2.eventTypes   = fds1.eventTypes;
fds2.aircraftData = fds1.aircraftData;
fds2.testInfo     = fds1.testInfo;

if isfield(fds1, 'Sensors')
    fds2.Sensors  = fds1.Sensors;
end

% other fields
fds2.BoardSupportPackage = fds1.BoardSupportPackage;
fds2.timeOffset          = fds1.timeOffset;
fds2.pathOpenedFrom      = fds1.pathOpenedFrom;
end