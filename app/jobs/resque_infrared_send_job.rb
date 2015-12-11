class ResqueInfraredSendJob
  @queue = :resque_infrared_send_job
  def self.perform(task)
    path = File.expand_path("log/resque_infrared_send_job.log", Rails.root)
    File.open(path, 'a') do |f|
      binding.pry
      schedule = Schedule.find_by(id:task["id"])
      infrared = schedule.infrared
      fname = infrared.data
      path = Rails.root.to_s
      command = File.join(path, 'commands/send')
      `#{command} #{path}/data/#{fname}`
      count = infrared.count + 1
      infrared.update(count: count)
      log = user.logs.create(name: "「#{schedule.name}」のスケジューラーが「#{infrared.name}」を実行しました", status: :robot_send_ir)
      log.infrared = infrared
    end
  end
end