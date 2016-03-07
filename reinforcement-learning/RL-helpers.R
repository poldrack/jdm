softmax = function(q,beta) {
  p=exp(q[1]*beta)/(exp(q[1]*beta)+exp(q[2]*beta))
  if (p>runif(1)) {
    return(1)
  } else {
    return(2)
  }
}

outcome = function(resp,correct_resp,p_A) {
  # correct_resp should be 1 or 2
  if (runif(1) < p_A) {
    rewarded_outcome=correct_resp
  } else {rewarded_outcome=abs(correct_resp-2)+1}
  if (resp==rewarded_outcome) {
    return(1)
  } else {return(0)}
}

get_correct_resp = function(ntrials=1000,nswitch=100) {
  # generate sequence of correct responses
  correct_resp=array(data=1,dim=ntrials)
  for (i in seq(1,ntrials,nswitch*2)) {
    correct_resp[i:(i+nswitch-1)]=2
  }
  return(correct_resp)
}

# forward model to generate data using q-learning
generate_data = function(learning_rate,beta,prob) {
  correct_resp=get_correct_resp()
  ntrials=length(correct_resp)
  q=matrix(data=0,nrow=ntrials,ncol=2)
  resp=array(dim=ntrials)
  reward=array(dim=ntrials)
  
  for (i in 1:ntrials) {
    if (i==1) {q[i,]=c(0,0)}
    else {q[i,]=q[i-1,]}
    
    resp[i]=softmax(q[i,],beta)
    reward[i]=outcome(resp[i],correct_resp[i],prob)
    q[i,resp[i]]=q[i,resp[i]] + learning_rate*(reward[i]-q[i,resp[i]])
  }
  return(list('q'=q,'resp'=resp,'reward'=reward))
}

# we will be using a minimization routine, so we return the negative log likelihood

q_negloglike=function(params,g) {
  lr=params[1]
  if (length(params)>1) {beta=params[2]}
  else {beta=1}
  
  q=c(0.0,0.0)
  ll_sum=0
  for (i in 1:length(g$resp)) {
    # log of choice probability (from Daw): β · Qt(ct) − log(exp(β · Qt(L)) + exp(β · Qt(R)))
    ll_sum = ll_sum + beta*q[g$resp[i]] - log(exp(q[1]*beta)+exp(q[2]*beta))
    q[g$resp[i]]=q[g$resp[i]] + lr*(g$reward[i]-q[g$resp[i]])
  }
  return(-1*ll_sum)
}

get_ll_surface=function(g) {
  lrvals=seq(0,0.25,0.01)
  tempvals=seq(0.1,20.1,0.1)
  ll=matrix(nrow=length(lrvals),ncol=length(tempvals))
  for (lr in 1:length(lrvals)){
    for (t in 1:length(tempvals)) {
      ll[lr,t]=q_negloglike(c(lrvals[lr],tempvals[t]),g=g)
    }
  }
  return(list('ll'=ll,'lrvals'=lrvals,'tempvals'=tempvals))
}
