class CalendarController < ApplicationController
  def initialize
    @date = DateTime.now
    @today = DateTime.now
    @date_string = @date.strftime("%A, %B %d, %Y")
    @first_day_wday = 0
    @reminder_days = Array.new
    @REMINDER_COLORS = ['#C8E6C9', '#F5DD29', '#FFCC80', '#EF9A9A', '#CD8DE5', '#5BA4CF', '#29CCE5', '#6DECA9', '#FF8ED4', '#BCAAA4']
  end

  def index
    now = DateTime.now
    redirect_to "/reminder/#{now.month}/#{now.day}/#{now.year}"
  end

  def reset_date_values(year, month, day)
    @date = Date.new(year, month, day)
    @date_string = @date.strftime("%A, %B %d, %Y")
    @first_day_wday = Date.new(year, month, 1).wday
    @reminder_days = Reminder.where(scheduled_datetime: Date.new(year, month, 1)..Date.new(year, month, -1)).map { |reminder| reminder.scheduled_datetime.day }
  end

  def show
    begin
      reset_date_values(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      date_reminders = Reminder.where(scheduled_datetime: @date.beginning_of_day..@date.end_of_day).order(:scheduled_datetime)
      if (date_reminders.empty?)
        raise ActiveRecord::RecordNotFound
      end

      render layout: "application", template: "calendar/show", :locals => {:date_reminders => date_reminders}
    rescue ActiveRecord::RecordNotFound => e
      render layout: "application", template: "calendar/empty"
    rescue Exception => e
      render_error(500)
    end

  end

  def new
    begin
      reset_date_values(params[:year].to_i, params[:month].to_i, params[:day].to_i)

      render layout: "application", template: "calendar/edit", :locals => {:mode => "add"}
    rescue ActiveRecord::RecordNotFound => e
      render layout: "application", template: "calendar/empty"
    end
  end

  def update
    begin
      reminder = Reminder.find_by!(id: params[:id])
      reminder.title = params[:title]
      reminder.description = params[:description]
      reminder.color = params[:color]
      reminder.scheduled_datetime = DateTime.strptime(params[:reminder_date] + 'T' + params[:reminder_time], "%m/%d/%YT%I:%M %p")
      reminder.save!

      render json: {}, status: 200
    rescue Exception => e
      render json: {'error' => e.message}, status: 500
    end
  end

  def save
    begin
      scheduled_datetime = DateTime.strptime(params[:reminder_date] + 'T' + params[:reminder_time], "%m/%d/%YT%I:%M %p")

      reminder = Reminder.new
      reminder.title = params[:title]
      reminder.description = params[:description]
      reminder.color = params[:color]
      reminder.scheduled_datetime = scheduled_datetime
      reminder.save()
      render json: reminder, status: 200
    rescue Exception => e
      puts e.message
      render json: {'error' => e.message}, status: 500
    end
  end

  def edit
    begin
      reminder = Reminder.find_by!(id: params[:id])
      reset_date_values(reminder.scheduled_datetime.year, reminder.scheduled_datetime.month, reminder.scheduled_datetime.day)

      render layout: "application", template: "calendar/edit", :locals => {:mode => "edit", :reminder => reminder}
    rescue ActiveRecord::RecordNotFound => e
      render_error(404)
    rescue Exception => e
      render_error(500)
    end
  end

  def destroy
    begin
      Reminder.where(id: params[:id]).destroy_all
      render json: {}, status: 200
    rescue Exception => e
      render json: {'error' => e.message}, status: 500
    end
  end

  private
    def calendar_params
      params.permit(:id, :title, :description, :color, :reminder_date, :reminder_time)
    end
end
