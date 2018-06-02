function [bInt,bExt] = checkStability(mA,mB,mC,mD,strSysType)
% CHECKSTABILITY check if a system is internally/externally stable
% Inputs:   - mA, mB, mC, mD: state-space matrices
%           - strSysType: string that is set to 'continuous' for
%           continuous-time systems or to 'discrete' for discrete-time
%           systems
% Outputs:  - bInt: boolean variable set to 'true' if the system is 
%           internally stable and to 'false' otherwise
%           - bExt: boolean variable set to 'true' if the system is
%           externally stable and to 'false' otherwise
% SEE ALSO
% STRCMP, SS, MINREAL,EIG

% continuous-time case
if strcmp(strSysType,'continuous')
    
    % checking internal stability 
    if real(eig(mA)) < 0
        bInt = true;
    else
        bInt = false;
    end
        
    % computing minimal realization
    sys_min = minreal(ss(mA,mB,mC,mD));
    [mAmin,~,~,~] = ssdata(sys_min);
    
    % checking external stability
    if real(eig(mAmin)) < 0
        bExt = true;
    else
        bExt = false;
    end

% discrete-time case
elseif strcmp(strSysType,'discrete')
    
    % checking internal stability 
    if abs(eig(mA)) < 1
        bInt = true;
    else
        bInt = false;
    end
        
    % computing minimal realization
    sys_min = minreal(ss(mA,mB,mC,mD,-1));
    [mAmin,~,~,~] = ssdata(sys_min);
    
    % checking external stability
    if abs(eig(mAmin)) < 1
        bExt = true;
    else
        bExt = false;
    end
else
    error('strSysType value not valid: please set it either to ''continuous'' or ''discrete''');
end