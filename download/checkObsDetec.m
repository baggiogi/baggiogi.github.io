function [bObs,bDetec] = checkObsDetec(mA,mC,strSysType)
% CHECKOBSDETEC Check if a system is reachable and stabilizable
% Inputs:   - mA, mB, mC, mD: state-space matrices
%           - strSysType: string that is set to 'continuous' for
%           continuous-time systems or to 'discrete' for discrete-time
%           systems
% Outputs:  - bObs: boolean variable set to 'true' if the system is
%           observable and to 'false' otherwise
%           - bDetec: boolean variable set to 'true' if the system is
%           detectable and to 'false' otherwise
% SEE ALSO
% STRCMP, SS, OBSV, RANK, EIG

iN = length(mA); % state space dimension

% continuous-time case
if strcmp(strSysType,'continuous')
    
    sys = ss(mA,[],mC,[]);
    
    % checking observability/detectability
    if rank(obsv(sys)) == iN % system is observable and therefore detectable
        bObs = true;
        bDetec = true;
    else % system is not observable
        bObs = false;
        bDetec = true;
        
        cvEigA = eig(mA);
        
        for iK = 1:iN % checking detectability
            if real(cvEigA(iK)) > 0
                if rank([mA - cvEigA(iK)*eye(iN); mC]) < iN
                    bDetec = false;
                end
            end
        end
        
    end
    
% discrete-time case
elseif strcmp(strSysType,'discrete')
    
    sys = ss(mA,[],mC,[],-1);
    
    % checking observability/detectability
    if rank(obsv(sys)) == iN % system is observable and therefore detectable
        bObs = true;
        bDetec = true;
    else % system is not observable
        bObs = false;
        bDetec = true;
        
        cvEigA = eig(mA);
        
        for iK = 1:iN % checking detectability
            if abs(cvEigA(iK)) >= 1
                if rank([mA - cvEigA(iK)*eye(iN); mC]) < iN
                    bDetec = false;
                end
            end
        end
        
    end
    
else
    error('strSysType value not valid: please set it either to ''continuous'' or ''discrete''');
end