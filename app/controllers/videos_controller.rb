class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.all
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
  end

  def secure_show
    @video = Video.where(:secure_id => params[:secure_id]).first
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @video }
    end
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create
    
    # time = ""
    # if video_params[:expires_at].length > 0
    #   Time.zone = 'UTC'
    #   time = Time.zone.strptime(video_params[:expires_at], '%m/%d/%Y %l:%M%p')
    #   logger.debug(video_params[:expires_at])
    #   logger.debug(time)
    #   logger.debug(time.class)
    #   offset = params[:offset]
    #   #time = time + offset.to_i.minutes
      
    #   #time = time.change(:offset => '-03:00')
      
    # end



    # video_params[:expires_at] = ""


    my_params = video_params
    
    if my_params[:expires_at].length > 0
     
      offset = ""
      if params[:offset].start_with?('-')
        offset = params[:offset]
      else
        offset = "+#{params[:offset]}"
      end
      my_params[:expires_at] = Time.zone.strptime("#{my_params[:expires_at]}#{offset}", '%m/%d/%Y %l:%M%p%z')
    end


    @video = Video.new(my_params)
    @video.secure_id = SecureRandom.urlsafe_base64
    

    respond_to do |format|
      if @video.save
        format.html { redirect_to "/videos/#{@video.secure_id}", notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:attachment_url, :expires_at, :secure_id)
    end
end
