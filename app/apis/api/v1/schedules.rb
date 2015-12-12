# app/apis/api/v1/users.rb

module API
  module V1
    class Schedules < Grape::API
      helpers do
        def integer_string?(str)
          Integer(str)
          true
        rescue ArgumentError
          false
        end

        def invalid_cron
          error!(meta: {
                         status: 400,
                         errors: [
                           message: ('errors.messages.invalid_cron'),
                           code: ErrorCodes::INVALID_CRON
                         ]
                       }, response: {})
        end
        def cron_check_value value, index
          if value =~ /^(([0-9]+)((\,||\-||\/)[0-9]+)*||\*(\/[0-9]+)?)$/
            if integer_string?(value) || value == "*"
              case index
              when 0 #分
                if value == "*"
                  return "毎分"
                elsif value.to_i <= 59 && value.to_i >= 0
                  return value + "分に"
                else
                  invalid_cron
                end
              when 1 #時
                if value == "*"
                  return "毎時"
                elsif value.to_i <= 23 && value.to_i >= 0
                  return value + "時"
                else
                  invalid_cron
                end
              when 2 #日
                if value == "*"
                  return "毎日"
                elsif value.to_i <= 31 && value.to_i >= 1
                  return value + "日"
                else
                  invalid_cron
                end
              when 3 #月
                if value == "*"
                  return "毎月"
                elsif value.to_i <= 12 && value.to_i >= 1
                  return value + "月"
                else
                  invalid_cron
                end
              when 4 #曜日
                if value == "*"
                  return "毎曜日の"
                elsif value.to_i <= 7 && value.to_i >= 0
                  case value.to_i
                  when 0
                    return "日曜日の"
                  when 1
                    return "月曜日の"
                  when 2
                    return "火曜日の"
                  when 3
                    return "水曜日の"
                  when 4
                    return "木曜日の"
                  when 5
                    return "金曜日の"
                  when 6
                    return "土曜日の"
                  when 7
                    return "日曜日の"
                  end
                else
                  invalid_cron
                end
              end
            else
              response = ""
              if value.include?("-")
                value.split("-").each_with_index do |val, i|
                  if i == 0
                    case index
                    when 0
                     response = response + val + "分から"
                    when 1
                     response = response + val + "時から"
                    when 2
                     response = response + val + "日から"
                    when 3
                     response = response + val + "月から"
                    when 4
                      case val.to_i
                      when 0
                        response = response + "日曜日から"
                      when 1
                        response = response + "月曜日から"
                      when 2
                        response = response + "火曜日から"
                      when 3
                        response = response + "水曜日から"
                      when 4
                        response = response + "木曜日から"
                      when 5
                        response = response + "金曜日から"
                      when 6
                        response = response + "土曜日から"
                      when 7
                        response = response + "日曜日から"
                      end
                    end
                  else
                    if val.include?("/")
                      val = val.split("/")[0]
                    end
                    case index
                    when 0
                     response = response + val + "分まで1分ごとに"
                    when 1
                     response = response + val + "時まで"
                    when 2
                     response = response + val + "日まで"
                    when 3
                     response = response + val + "月まで"
                    when 4
                      case val.to_i
                      when 0
                        response = response + "日曜日まで"
                      when 1
                        response = response + "月曜日まで"
                      when 2
                        response = response + "火曜日まで"
                      when 3
                        response = response + "水曜日まで"
                      when 4
                        response = response + "木曜日まで"
                      when 5
                        response = response + "金曜日まで"
                      when 6
                        response = response + "土曜日まで"
                      when 7
                        response = response + "日曜日まで"
                      end
                    end
                  end
                end
              end
              if value.include?("/")
                value.split("/").each_with_index do |val, i|
                  if i == 0
                    unless val.include?("-")
                      case index
                      when 0
                        if val == "*"
                        else
                          response = response + val + "分から"
                        end
                      when 1
                        if val == "*"
                        else
                          response = response + val + "時から"
                        end
                      when 2
                        if val == "*"
                        else
                          response = response + val + "日から"
                        end
                      when 3
                        if val == "*"
                        else
                          response = response + val + "月から"
                        end
                      when 4
                        case val.to_i
                        when 0
                          response = response + "日曜日から"
                        when 1
                          response = response + "月曜日から"
                        when 2
                          response = response + "火曜日から"
                        when 3
                          response = response + "水曜日から"
                        when 4
                          response = response + "木曜日から"
                        when 5
                          response = response + "金曜日から"
                        when 6
                          response = response + "土曜日から"
                        when 7
                          response = response + "日曜日から"
                        end
                      end
                    end
                  else
                    case index
                    when 0
                     response = response + val + "分おきに"
                    when 1
                     response = response + val + "時間おきに"
                    when 2
                     response = response + val + "日おきに"
                    when 3
                     response = response + val + "月おきに"
                    when 4
                      invalid_cron
                    end
                  end
                end
              end
              if value.include?(",")
                value.split(",").each_with_index do |val, i|
                  case index
                  when 0
                    response = response + val + "分と"
                  when 1
                    response = response + val + "時と"
                  when 2
                    response = response + val + "日と"
                  when 3
                    response = response + val + "月と"
                  when 4
                    case val.to_i
                    when 0
                      response = response + "日曜日と"
                    when 1
                      response = response + "月曜日と"
                    when 2
                      response = response + "火曜日と"
                    when 3
                      response = response + "水曜日と"
                    when 4
                      response = response + "木曜日と"
                    when 5
                      response = response + "金曜日と"
                    when 6
                      response = response + "土曜日と"
                    when 7
                      response = response + "日曜日と"
                    end
                  end
                end
                if index == 0
                  response.gsub!(/と$/u, "に")
                else
                  response.gsub!(/と$/u, "の")
                end
              end
              return response
            end
          else
            invalid_cron
          end
        end
      end
      resource :schedule do
        desc 'スケジュールの停止', notes: <<-NOTE
            <h1>スケジュールを停止します</h1>
          NOTE
        params do
          requires :auth_token, type: String, desc: 'Auth token.'
          requires :schedule_id, type: Integer, desc: 'Schedule id'
        end
        post '/remove', jbuilder: 'api/v1/schedule/remove' do
          if (token = AuthToken.find_by(token: params[:auth_token]))
            if user.info.nil?
              error!(meta: {
                       status: 400,
                       errors: [
                         message: ('errors.messages.user_not_found'),
                         code: ErrorCodes::NOT_FOUND_USER
                       ]
                     }, response: {})
            else
              if schedule = user.schedules.find_by(id: params[:schedule_id])
                remove_schedule(schedule.job_name)
                @schedule = schedule
              else
                error!(meta: {
                       status: 400,
                       errors: [
                         message: ('errors.messages.schedule_not_found'),
                         code: ErrorCodes::NOT_FOUND_SCHEDULE
                       ]
                     }, response: {})
              end
            end
          else
            error!(meta: {
                     status: 400,
                     errors: [
                       message: ('errors.messages.invalid_token'),
                       code: ErrorCodes::INVALID_TOKEN
                     ]
                   }, response: {})
          end
        end
      end
      resource :schedule do
        desc 'スケジュールの作成', notes: <<-NOTE
            <h1>スケジュールを作成します</h1>
            <p>
            cronの設定には気をつけてね
            </p>
          NOTE
        params do
          requires :auth_token, type: String, desc: 'Auth token.'
          requires :ir_id, type: Integer, desc: 'Auth token.'
          requires :name, type: String, desc: 'Auth token.'
          requires :cron, type: String, desc: 'Auth token.'
        end
        post '/', jbuilder: 'api/v1/schedule/create' do
          if (token = AuthToken.find_by(token: params[:auth_token]))
            if user.info.nil?
              error!(meta: {
                       status: 400,
                       errors: [
                         message: ('errors.messages.user_not_found'),
                         code: ErrorCodes::NOT_FOUND_USER
                       ]
                     }, response: {})
            else
              if(infrared = Infrared.find_by(id: params[:ir_id]))
                cron = params[:cron]
                cron_a = cron.split(" ")
                message = " "
                isEveryWord = false
                if cron_a.size == 5
                  cron_a.each_with_index do |c, index|
                    if cron_check_value(c,index).to_s.include?("毎")
                      if isEveryWord
                      else
                        isEveryWord =true
                        message = cron_check_value(c,index).to_s + message
                      end
                    else
                      if index == 4 && cron_a[4] != "*"
                        message.gsub!(/毎日/u,"")
                        message.gsub!(/毎月/u,"")
                        message = cron_check_value(c,index).to_s + message
                        if cron_a[2] != "*"
                          message.gsub!(/曜日の/u,"曜日と")
                        end
                      else
                        message = cron_check_value(c,index).to_s + message
                      end
                    end
                  end
                  message.gsub!(/時毎分/u,"時に毎分")
                  message = message + "実行します"
                  schedule = user.schedules.create(name: params[:name], cron: params[:cron])
                  cron = params[:cron]
                  schedule.update(description: "#{message}", cron: "#{cron}", job_name: "schedule_#{user.id}_#{schedule.id}")
                  infrared.schedule = schedule
                  Resque.set_schedule("#{schedule.job_name}", { class: "ResqueInfraredSendJob", cron: cron, args: schedule})
                  @schedule = schedule
                  @message = message
                else
                  error!(meta: {
                         status: 400,
                         errors: [
                           message: ('errors.messages.invalid_cron'),
                           code: ErrorCodes::INVALID_CRON
                         ]
                       }, response: {})
                end
              else
                error!(meta: {
                         status: 400,
                         errors: [
                           message: ('errors.messages.ir_not_found'),
                           code: ErrorCodes::NOT_FOUND
                         ]
                       }, response: {})
              end
            end
          else
            error!(meta: {
                     status: 400,
                     errors: [
                       message: ('errors.messages.invalid_token'),
                       code: ErrorCodes::INVALID_TOKEN
                     ]
                   }, response: {})
          end
        end
      end
    end
  end
end