class SpeedometerViewController < UIViewController
  M_PI = 3.14

  def viewDidLoad
    @r = Random.new(1234)
    addMeterViewContents
    true
  end

  def addImageView(image_name, frame)
    theView = UIImageView.alloc.initWithFrame(frame)
    theView.image = UIImage.imageNamed(image_name)
    view.addSubview(theView)
    theView
  end

  def addMeterViewContents
    backgroundImageView = UIImageView.alloc.initWithFrame(CGRectMake(0, 0, 320, 460))
    backgroundImageView.image = UIImage.imageNamed("main_bg.png")
    view.addSubview(backgroundImageView)
    #addImageView("main_bg.png", CGRectMake(0, 0, 320, 460))
    meterImageView = UIImageView.alloc.initWithFrame(CGRectMake(10, 40, 286, 315))
    meterImageView.image = UIImage.imageNamed("meter.png")
    view.addSubview(meterImageView)

    #Needle
    imgNeedle = UIImageView.alloc.initWithFrame(CGRectMake(143, 155, 22, 84))
    @needleImageView = imgNeedle

    @needleImageView.layer.anchorPoint = CGPointMake(@needleImageView.layer.anchorPoint.x, @needleImageView.layer.anchorPoint.y*2)
    @needleImageView.backgroundColor = UIColor.clearColor
    @needleImageView.image = UIImage.imageNamed("arrow.png")
    view.addSubview(@needleImageView)

    # Needle Dot
    meterImageViewDot = UIImageView.alloc.initWithFrame(CGRectMake(131.5, 175, 45, 44))
    meterImageViewDot.image = UIImage.imageNamed("center_wheel.png")
    view.addSubview(meterImageViewDot)


    # Speedometer Reading
    tempReading = UILabel.alloc.initWithFrame(CGRectMake(125, 250, 60, 30))
    @speedometerReading = tempReading
    @speedometerReading.textAlignment = UITextAlignmentCenter
    @speedometerReading.backgroundColor = UIColor.blackColor
    @speedometerReading.text= "0"
    @speedometerReading.textColor = UIColor.colorWithRed(114/ 255, green: 146/255, blue: 38/255, alpha: 1.0)
    view.addSubview(@speedometerReading)

    # Set Max Value
    @maxVal = 100

    #Set Needle pointer initialy at zero //
    rotateIt(-118.4)

    #Set previous angle
    @prevAngleFactor = -118.4

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

      UIView.beginAnimations(nil, context: nil)
      UIView.setAnimationDuration(0.5)
      rotateIt(@angle/3)
      UIView.commitAnimations

      UIView.beginAnimations(nil, context: nil)
      UIView.setAnimationDuration(0.5)
      rotateIt((@angle*2)/3)
      UIView.commitAnimations

    end

    @prevAngleFactor = @angle
    # Rotate Needle //
    rotateNeedle
  end

  def rotateNeedle
    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(0.5)
    @needleImageView.setTransform(CGAffineTransformMakeRotation((M_PI / 180) * @angle))
    UIView.commitAnimations
  end


  def setSpeedometerCurrentValue
    if @speedometer_Timer
      @speedometer_Timer.invalidate
      #@speedometer_Timer = nil
    end


    @speedometerCurrentValue = @r.rand(0..100) # Generate Random value between 0 to 100.

    @speedometer_Timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "setSpeedometerCurrentValue", userInfo: nil, repeats: true)
    @speedometerReading.text = "%.2f"%@speedometerCurrentValue

    # Calculate the Angle by which the needle should rotate //
    calculateDeviationAngle
  end


  def rotateIt(angl)
    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(0.01)
    @needleImageView.setTransform(CGAffineTransformMakeRotation((M_PI / 180) * angl))
    UIView.commitAnimations
  end

end
