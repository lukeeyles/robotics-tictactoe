function pose = OdometryTo2DPose(msg)
pose = [msg.Pose.Pose.Position.X,...
    msg.Pose.Pose.Position.Y,...
    2*acos(msg.Pose.Pose.Orientation.W)];