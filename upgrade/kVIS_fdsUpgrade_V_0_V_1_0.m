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

function [ fds ] = kVIS_fdsUpgrade_V_0_V_1_0(fdsOld)
    % Upgrade FDS from V 0 (produced by fds_upgrade_legacy) to V 1.0.
    % For KSID internal use only. Use fds_upgrade(fds) instead.

    fds = kVIS_fdsInitNew();

    timeGlobal = fdsOld.t(:);

    fdataRows = fds.fdataRows;
    fdataRowsOld = fdsOld.fdataRows;

    fds.fdata = cell(size(fds.fdata, 1), size(fdsOld.fdata, 2));
    fds.fdata(fdataRows.groupLabel, :)      = fdsOld.fdata(fdataRowsOld.Label, :);
    fds.fdata(fdataRows.varNames, :)        = fdsOld.fdata(fdataRowsOld.Vars, :);
    fds.fdata(fdataRows.varUnits, :)        = fdsOld.fdata(fdataRowsOld.Units, :);
    
    % fill 'frames' fields with empty arrays of correct dimensions
    fds.fdata(fdataRows.varFrames, :)       = fdsOld.fdata(fdataRowsOld.Vars, :);
        
    fds.fdata(fdataRows.varNamesDisp, :)    = fds.fdata(fdataRows.varNames, :);
    fds.fdata(fdataRows.data, :)            = fdsOld.fdata(fdataRowsOld.Data, :); % TODO
    fds.fdata(fdataRows.treeParent, :)      = fdsOld.fdata(fdataRowsOld.Parent, :);
    fds.fdata(fdataRows.treeGroupExpanded, :) = {false};
    fds.fdata(fdataRows.treeGroupSelected, :) = {false};

    % add time vector to all groups
    for k = 1 : size(fds.fdata, 2)
        
        % only check data leafs 
        if size(fds.fdata{fdataRows.varNames, k}, 2) > 0
            
            % strip whitespace from names
            fds.fdata{fdataRows.varNames, k} = strip(fds.fdata{fdataRows.varNames, k});
            
            % empty frames fields
            fds.fdata{fdataRows.varFrames, k}       = cellfun(@(x) '', fds.fdata{fdataRows.varFrames, k}, 'UniformOutput', false);
            
            
            timeChannelIdx = find(strcmpi(fds.fdata{fdataRows.varNames, k}, 'Time'), 1, 'first');
            
            if isempty(timeChannelIdx)
                % add time channel
                fds.fdata{fdataRows.varNames    , k} = ['Time'    ; fds.fdata{fdataRows.varNames    , k}];
                fds.fdata{fdataRows.varUnits    , k} = ['sec'     ; fds.fdata{fdataRows.varUnits    , k}];
                fds.fdata{fdataRows.varFrames   , k} = [''        ; fds.fdata{fdataRows.varFrames   , k}];
                fds.fdata{fdataRows.varNamesDisp, k} = ['Time'    ; fds.fdata{fdataRows.varNamesDisp, k}];
                fds.fdata{fdataRows.data        , k} = [timeGlobal; fds.fdata{fdataRows.data        , k}];
            else
                % move time channel to idx 1
                idx = [1, timeChannelIdx];
                flipIdx = fliplr(idx);
                fds.fdata(fdataRows.varNames    , idx) = fds.fdata(fdataRows.varNames    , flipIdx);
                fds.fdata(fdataRows.varUnits    , idx) = fds.fdata(fdataRows.varUnits    , flipIdx);
                fds.fdata(fdataRows.varFrames   , idx) = fds.fdata(fdataRows.varFrames   , flipIdx);
                fds.fdata(fdataRows.varNamesDisp, idx) = fds.fdata(fdataRows.varNamesDisp, flipIdx);
                fds.fdata(fdataRows.data        , idx) = fds.fdata(fdataRows.data        , flipIdx);
            end
        end
    end

    fds = kVIS_fdsUpdateAttributes(fds);

    % TODO: fds.eventList, fds.eventTypes

    % fds.aircraftData
    if isfield(fdsOld, 'ACconfig')
        
        fds.aircraftData.sRef_UNIT_m2   = fdsOld.ACconfig.sref;
        fds.aircraftData.cRef_UNIT_m    = fdsOld.ACconfig.cref;
        fds.aircraftData.bRef_UNIT_m    = fdsOld.ACconfig.bref;
        fds.aircraftData.mass_UNIT_kg   = fdsOld.ACconfig.mass;
        fds.aircraftData.ixx_UNIT_kgm2  = fdsOld.ACconfig.ixx;
        fds.aircraftData.iyy_UNIT_kgm2  = fdsOld.ACconfig.iyy;
        fds.aircraftData.izz_UNIT_kgm2  = fdsOld.ACconfig.izz;
        fds.aircraftData.ixz_UNIT_kgm2  = fdsOld.ACconfig.ixz;
        fds.aircraftData.xCG_UNIT_m     = fdsOld.ACconfig.xcg;
        fds.aircraftData.yCG_UNIT_m     = fdsOld.ACconfig.ycg;
        fds.aircraftData.zCG_UNIT_m     = fdsOld.ACconfig.zcg;
        
        if isfield(fdsOld.ACconfig, 'gravity')
            fds.testInfo.gravity_UNIT_m_d_s2 = fdsOld.ACconfig.gravity;
        end
        
    end

    % TODO: fds.testInfo

    if isempty(fdsOld.BoardSupportPackage)
        fds.BoardSupportPackage = 'generic';
    else
        fds.BoardSupportPackage = fdsOld.BoardSupportPackage;
    end

    fds.timeOffset = fdsOld.offset;

end
