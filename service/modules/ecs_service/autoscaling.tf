resource "aws_appautoscaling_target" "desired_count" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.ecs_service.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.service_min_count
  max_capacity       = var.service_max_count
}

resource "aws_appautoscaling_policy" "cpu_tracking" {
  name               = "${local.family}-autoscaling-desired-count-cpu-tracking"
  policy_type        = "TargetTrackingScaling"
  service_namespace  = aws_appautoscaling_target.desired_count.service_namespace
  resource_id        = aws_appautoscaling_target.desired_count.resource_id
  scalable_dimension = aws_appautoscaling_target.desired_count.scalable_dimension

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.cpu_utilization_target
    scale_in_cooldown  = var.cpu_utilization_scale_in_cooldown
    scale_out_cooldown = var.cpu_utilization_scale_up_cooldown
  }

  depends_on = [aws_appautoscaling_target.desired_count]
}
