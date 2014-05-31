get '/quiz/start' do
  session['current'] = -1;
  session['questions'] = Question.all(:conditions => ['owner_id <> ?', current_user.id]).shuffle.take(10);
  redirect '/quiz/next'
end

get '/quiz/show' do
  question =  session['questions'][session['current']];
  haml :show, :locals => {
    :q => question,
    :is_next => session['current'] < session['questions'].size - 1,
    :is_prev => session['current'] >= 1,
    :is_end => session['current'] == session['questions'].size - 1,
    :selected => session['quiz_'+question.id.to_s]
  }
end

post '/quiz/route' do
  id = params[:qid];
  session['quiz_'+id.to_s] = params['quiz_'+id.to_s];
  if (params['next'] != nil)
    redirect '/quiz/next'
  elsif (params['prev'] != nil)
    redirect '/quiz/prev'
  elsif (params['finish'] != nil)
    redirect '/quiz/finish'
  end
end

get '/quiz/next' do
  session['current'] += 1;
  redirect '/quiz/show'
end

get '/quiz/prev' do
  session['current'] -= 1;
  redirect '/quiz/show'
end

get '/quiz/finish' do
  correct = 0.0;
  questions = session['questions'];
  questions.each { |q|
    if (q.correct.id.to_s == session['quiz_'+q.id.to_s])
      correct += 1
    end
    session['quiz_'+q.id.to_s] = nil
  }

  QuizStats.create(:owner => DmUser.get(current_user.id),
    :result=>(correct*100 / questions.size))

  session['questions'] = nil
  haml :result, :locals => {:result=> (correct*100/ questions.size)}
end