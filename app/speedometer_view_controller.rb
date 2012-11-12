class SpeedometerViewController < UIViewController
  M_PI = 3.14

  def viewDidLoad
    #Set Max Value
    @maxVal = 100
    #Set previous angle
    @prevAngleFactor = -118.4
    @r = Random.new(1234)
    addMeterViewContents
    true
  end

  def addMeterViewContents
    addImageView("main_bg.png", CGRectMake(0, 0, 320, 460))
    addImageView("meter.png", CGRectMake(10, 40, 286, 315))
    #Needle
    @needleImageView = UIImageView.alloc.initWithFrame(CGRectMake(143, 155, 22, 84))

    @needleImageView.layer.anchorPoint = CGPointMake(@needleImageView.layer.anchorPoint.x, @needleImageView.layer.anchorPoint.y*2)
    @needleImageView.backgroundColor = UIColor.clearColor
    @needleImageView.image = UIImage.imageNamed("arrow.png")
    view.addSubview(@needleImageView)

    # Needle Dot
    addImageView("center_wheel.png", CGRectMake(131.5, 175, 45, 44))

    # Speedometer Reading
    @speedometerReading = UILabel.alloc.initWithFrame(CGRectMake(125, 250, 60, 30))
    @speedometerReading.textAlignment = UITextAlignmentCenter
    @speedometerReading.backgroundColor = UIColor.blackColor
    @speedometerReading.text= "0"
    @speedometerReading.textColor = UIColor.whiteColor # colorWithRed(114/ 255, green: 146/255, blue: 38/255, alpha: 1.0)
    view.addSubview(@speedometerReading)

    #Set Needle pointer initially at zero
    rotateIt(@prevAngleFactor)

    #Set Speedometer Value
    setSpeedometerCurrentValue
  end


  def calculateDeviationAngle
    if (@maxVal>0)
      @angle = ((@speedometerCurrentValue *237.4)/@maxVal)-118.4 # 237.4 - Total angle between 0 - 100
    else
      @angle = 0
    end

    if @angle<=-118.4
      @angle = -118.4
    end
    if @angle>=119
      @angle = 119
    end

    #If Calculated angle is greater than 180 deg, to avoid the needle to rotate in reverse direction first rotate the needle 1/3 of the calculated angle and then 2/3.//
    if ((@angle-@prevAngleFactor).abs >180)
      doAnimation(0.5) do
        rotateIt(@angle/3)
      end
      doAnimation(0.5) do
        rotateIt((@angle*2)/3)
      end
    end

    @prevAngleFactor = @angle
    # Rotate Needle
    rotateNeedle
  end


  def rotateNeedle
    doAnimation(0.5) do
      @needleImageView.setTransform(CGAffineTransformMakeRotation((M_PI / 180) * @angle))
    end
  end


  def setSpeedometerCurrentValue
    if @speedometer_Timer
      @speedometer_Timer.invalidate
    end
    @speedometerCurrentValue = @r.rand(0..100) # Generate Random value between 0 to 100.

    @speedometer_Timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "setSpeedometerCurrentValue", userInfo: nil, repeats: true)
    @speedometerReading.text = "%.2f"%@speedometerCurrentValue

    # Calculate the Angle by which the needle should rotate
    calculateDeviationAngle
  end


  def rotateIt(angle)
    doAnimation(0.01) do
      @needleImageView.setTransform(CGAffineTransformMakeRotation((M_PI / 180) * angle))
    end
  end

  def doAnimation duration
    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(duration)
    yield
    UIView.commitAnimations
  end

  def addImageView(image_name, frame)
    theView = UIImageView.alloc.initWithFrame(frame)
    theView.image = UIImage.imageNamed(image_name)
    view.addSubview(theView)
    theView
  end

end
