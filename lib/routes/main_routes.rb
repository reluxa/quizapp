get '/' do
  stats = Hash.new;
  qresult = Hash.new;

  users = DmUser.all
  users.each {|user|
    fname = user.email.split(".")[0]
    stats.store(fname, 0)

    item = Hash.new
    item[:min] = QuizStats.min(:result, :conditions => ['owner_id = ?', user.id])
    item[:max] = QuizStats.max(:result, :conditions => ['owner_id = ?', user.id])
    item[:avg] = QuizStats.avg(:result, :conditions => ['owner_id = ?', user.id])
    
    item[:min] ||= 0
    item[:max] ||= 0
    
    qresult.store(fname,item)
  }

  questions = Question.all
  questions.each { |q|
    fname = q.owner.email.split(".")[0]
    value = stats.fetch(fname, 0);
    stats.store(fname, value+1)
  }


  haml :index, :layout => :layout, :locals => {
    :total => questions.size,
    :stats => stats,
    :qresult => qresult,
    :finished => QuizStats.all.size,
    }
end

before '/quiz/*' do
    login_required
end

before '/question/*' do
    login_required
end