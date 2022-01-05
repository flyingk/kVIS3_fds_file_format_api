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

function [ fds ] = kVIS_fdsUpgrade(fds)
% Upgrade FDS to current storage format.

currentVersion = 1.0;

assert(isstruct(fds), 'FDS must be a struct');

if ~isfield(fds, 'fdsVersion')
    % legacy format
    fds.fdsVersion = -1;
end

while fds.fdsVersion <= currentVersion
    switch fds.fdsVersion
        case 1.0
            fds = UpgradeInfoStructs(fds);
            break;
        case 0
            fds = kVIS_fdsUpgrade_V_0_V_1_0(fds);
        case -1
            fds = kVIS_fdsUpgradeLegacy(fds);
        otherwise
            error('Unsupported FDS version: %s', fds.fdsVersion);
    end
end

if fds.fdsVersion >= 1.0
    kVIS_fdsValidate(fds);
end

end



function fds = UpgradeInfoStructs(fds)

if isfield(fds.aircraftData, 'sRef')
    
    aircraftData                = fds.aircraftData;
    aircraftData.sRef_UNIT_m2   = fds.aircraftData.sRef;
    aircraftData.cRef_UNIT_m    = fds.aircraftData.cRef;
    aircraftData.bRef_UNIT_m    = fds.aircraftData.bRef;
    aircraftData.mass_UNIT_kg   = fds.aircraftData.mass;
    aircraftData.ixx_UNIT_kgm2  = fds.aircraftData.ixx;
    aircraftData.iyy_UNIT_kgm2  = fds.aircraftData.iyy;
    aircraftData.izz_UNIT_kgm2  = fds.aircraftData.izz;
    aircraftData.ixz_UNIT_kgm2  = fds.aircraftData.ixz;
    aircraftData.xCG_UNIT_m     = fds.aircraftData.xCG;
    aircraftData.yCG_UNIT_m     = fds.aircraftData.yCG;
    aircraftData.zCG_UNIT_m     = fds.aircraftData.zCG;
    
    aircraftData = rmfield(aircraftData, {
        'sRef'
        'cRef'
        'bRef'
        'mass'
        'ixx'
        'iyy'
        'izz'
        'ixz'
        'xCG'
        'yCG'
        'zCG'
        });
    
    fds.aircraftData = aircraftData;
    
    testInfo                           = fds.testInfo;
    
    old_test_info_fieldnames = {
        'airfieldElevation'
        'windDir'
        'windSpeed'
        'ambientPressure'
        'ambientTemperature'
        'gravity'
        'magRef_N'
        'magRef_E'
        'magRef_D'
        };
    
    new_test_info_field_names = {
        'airfieldElevation_UNIT_m'
        'windDir_UNIT_deg'
        'windSpeed_UNIT_m_d_s'
        'ambientPressure_UNIT_Pa'
        'ambientTemperature_UNIT_C'
        'gravity_UNIT_m_d_s2'
        'magRef_N_UNIT_Gauss'
        'magRef_E_UNIT_Gauss'
        'magRef_D_UNIT_Gauss'
        };
    
    for i=1:numel(new_test_info_field_names)
        if isfield(fds.testInfo,old_test_info_fieldnames{i})
            testInfo.(new_test_info_field_names{i}) = fds.testInfo.(old_test_info_fieldnames{i});
            testInfo = rmfield(testInfo, old_test_info_fieldnames{i});
        else
            testInfo.(new_test_info_field_names{i}) = nan;
        end
    end
    fds.testInfo = testInfo;
    
else
    
    fds = fds;
    
end

end