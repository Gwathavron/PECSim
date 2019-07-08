function status = odestatbar(t,y,flag,varargin)

global t_start
persistent tfinal owbar tlastcall
    
if isempty(flag)
	% update only if more than 0.01 sec elapsed
 	if cputime-tlastcall>0.01        
        tlastcall = cputime;
        time = mean(t);
		waitbar(time/tfinal,owbar,sprintf('Simulation is running: %.2f s \n Current solution at time = %.4f',toc(t_start),t(end)));
    % terminate if less than 0.01sec elapsed
 	else
 		status = 0;
 		return
    end
else % initialization / end
  switch(flag)
  case 'init'
        owbar = waitbar(0,sprintf('Simulation is running: 0 s \n Current solution at time = 0') ,'Name','ODE integration','CreateCancelBtn',@cancleodestatbar);
	    tfinal = t(end);
	    tlastcall = cputime;
  case 'done'
	delete(owbar)   
  end
end

status = 0;

