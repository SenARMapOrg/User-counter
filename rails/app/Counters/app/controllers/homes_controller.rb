class HomesController < ApplicationController
  def index
  end

  def redirect_user
    name = params[:name].presence || Counter::UNNAMED
    cookie_key = "c_#{Digest::SHA256.hexdigest(name)[0, 16]}"
    unless cookies[cookie_key]
      Counter.create!(name: name)
      cookies[cookie_key] = { value: "1", expires: 24.hours.from_now }
    end
    destination = params[:url].presence || root_url
    redirect_to destination, allow_other_host: true
  end

  def control
    tracked    = TrackedName.order(:name).pluck(:name)
    raw_counts = Counter.group(:name).count
    all_names  = (tracked + raw_counts.keys).uniq

    @counts = all_names.sort_by { |n| [-raw_counts.fetch(n, 0), n] }
                       .map { |n| [n, raw_counts.fetch(n, 0)] }
                       .to_h
    @total              = Counter.count
    @registered_total   = Counter.where(name: tracked).count
    @unregistered_total = @total - @registered_total
    @tracked_names      = tracked
    @redirect_base      = "#{request.base_url}/redirect"

    raw_time = Counter.group("DATE(CONVERT_TZ(created_at, 'UTC', 'Asia/Tokyo'))", "HOUR(CONVERT_TZ(created_at, 'UTC', 'Asia/Tokyo'))", :name).count
    @time_stats = raw_time.each_with_object({}) do |((date, hour, name), count), h|
      h[[date, hour]] ||= {}
      h[[date, hour]][name] = count
    end
    @time_slots = @time_stats.keys.sort_by { |date, hour| [-date.to_time.to_i, -hour] }
  end

  def create_name
    name = params[:name].to_s.strip
    if name.present?
      TrackedName.find_or_create_by!(name: name)
      flash[:notice] = "「#{name}」を追加しました"
    else
      flash[:alert] = "名前を入力してください"
    end
    redirect_to redirect_control_path
  end

  def destroy_name
    TrackedName.find_by(name: params[:name])&.destroy
    redirect_to redirect_control_path
  end

  def reset_counters
    name = params[:name]
    if name.present?
      Counter.where(name: name).delete_all
      flash[:notice] = "「#{name}」のカウントをリセットしました"
    else
      Counter.delete_all
      flash[:notice] = "全カウントをリセットしました"
    end
    redirect_to redirect_control_path
  end
end
