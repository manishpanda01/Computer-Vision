function E=Eigen_Deflate(E,method,parameter)
%E- Eigenmodel
%method - Deflation method used
%param -optional parameter
    switch method      
        case 'keepn' %Keep most significant eigenvectors
            E.val=E.val(1:parameter);
            E.vct=E.vct(:,1:parameter);
        case 'keepf' %keep percentage of energy
            total_energy=sum(abs(E.val));
            current_energy=0;
            rank=0;
            for i=1:size(E.vct,2)
                if current_energy>(total_energy*parameter)
                    break;
                end
                rank=rank+1;
                current_energy=current_energy+E.val(i);
            end
            E=Eigen_Deflate(E,'keepn',rank);
    
    end
    
    