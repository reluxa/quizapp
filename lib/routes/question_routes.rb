get '/question/add' do
  haml :edit, :locals => {:q => Question.new}
end

post '/question/modify' do
  haml :edit, :locals => {:q => Question.get(Integer(params[:qid]))}
end

get '/question/list' do
  haml :list, :locals => {:qs => Question.all}
end

post '/question/create' do
  quiz= params[:quiz]
  question = Question.create(:title => quiz[:q])
  question.answers.push(Answer.create(:mtext => quiz[:a0]))
  question.answers.push(Answer.create(:mtext => quiz[:a1]))
  question.answers.push(Answer.create(:mtext => quiz[:a2])) if quiz[:a2] != nil && quiz[:a2].chomp.length > 0;
  question.owner = DmUser.get(current_user.id)
  question.save
  question.correct = question.answers[Integer(quiz[:r])]
  question.save
  redirect "/question/list"
end

post '/question/update' do
  quiz= params[:quiz]
  qid = params[:qid]
  question = Question.get(Integer(qid))
  question.title = quiz[:q]

  question.answers.each { |answer|
    answer.destroy
  }
  question.answers.clear
  question.answers.push(Answer.create(:mtext => quiz[:a0]))
  question.answers.push(Answer.create(:mtext => quiz[:a1]))
  question.answers.push(Answer.create(:mtext => quiz[:a2])) if quiz[:a2] != nil && quiz[:a2].chomp.length > 0;
  question.save
  question.correct = question.answers[Integer(quiz[:r])]
  question.save
  redirect "/question/list"
end

post '/question/delete' do
  qid = params[:qid]
  question = Question.get(Integer(qid))
  question.answers.each { |answer|
    answer.destroy
  }
  question.answers.clear
  question.destroy
  redirect "/question/list"
end
