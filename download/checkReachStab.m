function [bReach,bStab] = checkReachStab(mA,mB,strSysType)
% CHECKREACHSTAB Check if a system is reachable and stabilizable
% Inputs:   - mA, mB, mC, mD: state-space matrices
%           - strSysType: string that is set to 'continuous' for
%           continuous-time systems or to 'discrete' for discrete-time
%           systems
% Outputs:  - bReach: boolean variable set to 'true' if the system is
%           reachable and to 'false' otherwise
%           - bStab: boolean variable set to 'true' if the system is
%           stabilizable and to 'false' otherwise
% SEE ALSO
% STRCMP, SS, CTRB, RANK, EIG

iN = length(mA); % state space dimension

% continuous-time case
if strcmp(strSysType,'continuous')
    
    sys = ss(mA,mB,[],[]);
    
    % checking reachability/stabilizability
    if rank(ctrb(sys)) == iN % system is reachable and therefore stabilizable
        bReach = true;
        bStab = true;
    else % system is not reachable
        bReach = false;
        bStab = true;
        
        cvEigA = eig(mA);
        
        for iK = 1:iN % checking stabilizability
            if real(cvEigA(iK)) > 0
                if rank([mA - cvEigA(iK)*eye(iN), mB]) < iN
                    bStab = false;
                end
            end
        end
        
    end
   
% discrete-time case
elseif strcmp(strSysType,'discrete')
    
    sys = ss(mA,mB,[],[],-1);
    
    if rank(ctrb(sys)) == iN % system is reachable and therefore stabilizable
        bReach = true;
        bStab = true;
    else % system is not reachable
        bReach = false;
        bStab = true;
        
        cvEigA = eig(mA);
        
        for iK = 1:iN % checking stabilizability
            if abs(cvEigA(iK)) >= 1
                if rank([mA - cvEigA(iK)*eye(iN), mB]) < iN
                    bStab = false;
                end
            end
        end
        
    end
    
else
    error('strSysType value not valid: please set it either to ''continuous'' or ''discrete''');
end