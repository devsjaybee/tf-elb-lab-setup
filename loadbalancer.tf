resource "aws_lb" "web-lb" {
  name               = "web-lb"
  //ip_address_type    =  "dualstack"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-sg.id]
  subnets            = [aws_subnet.web-1a.id, aws_subnet.web-1b.id]

  enable_deletion_protection = false

  tags = {
    Name = "web-lb"
  }
}

# aws_lb_target_group_web
resource "aws_lb_target_group" "web-servers" {
  name        = "web-servers-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_webapp.id

  health_check {
   
    # Specify a valid URI (protocol://hostname/path?query).
    path = var.health_check_path

      # The port the load balancer uses when performing health checks on targets.
    # The default is to use the port on which each target receives traffic from the load balancer.
    # Valid values are either ports 1-65536, or traffic-port.
    port = var.health_check_port

    # The number of consecutive successful health checks required before considering an unhealthy target healthy.
    # The range is 2–10.
    healthy_threshold = var.health_check_healthy_threshold

    # The number of consecutive failed health checks required before considering a target unhealthy.
    # The range is 2–10.
    unhealthy_threshold = var.health_check_unhealthy_threshold

    # The amount of time, in seconds, during which no response from a target means a failed health check.
    # The range is 2–60 seconds.
    timeout = var.health_check_timeout

    # The approximate amount of time, in seconds, between health checks of an individual target.
    # The range is 5–300 seconds.
    interval = var.health_check_interval

    # The HTTP codes to use when checking for a successful response from a target.
    # You can specify multiple values (for example, "200,202") or a range of values (for example, "200-299").
    matcher = var.health_check_matcher

    # The protocol the load balancer uses when performing health checks on targets.
    # The possible protocols are HTTP and HTTPS.
    protocol = var.health_check_protocol
  }
}

# aws_lb_lister
resource "aws_lb_listener" "web-servers" {
  load_balancer_arn = aws_lb.web-lb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-servers.arn
  }
}

# aws_lb_targe_group_attachment_web
resource "aws_lb_target_group_attachment" "web-app-1" {
  target_group_arn = aws_lb_target_group.web-servers.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web-app-2" {
  target_group_arn = aws_lb_target_group.web-servers.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web-app-3" {
  target_group_arn = aws_lb_target_group.web-servers.arn
  target_id        = aws_instance.web3.id
  port             = 80
}

#### LB-APP ######

resource "aws_lb" "app-lb" {
  name               = "app-lb"
  //ip_address_type    =  "dualstack"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app-sg.id]
  subnets            = [aws_subnet.app-1a.id, aws_subnet.app-1b.id]

  enable_deletion_protection = false

  tags = {
    Name = "app-lb"
  }
}

# aws_lb_target_group_app
resource "aws_lb_target_group" "app-servers" {
  name        = "app-servers-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_webapp.id

  health_check {
   
    # Specify a valid URI (protocol://hostname/path?query).
    path = var.app_health_check_path

      # The port the load balancer uses when performing health checks on targets.
    # The default is to use the port on which each target receives traffic from the load balancer.
    # Valid values are either ports 1-65536, or traffic-port.
    port = var.app_health_check_port

    # The number of consecutive successful health checks required before considering an unhealthy target healthy.
    # The range is 2–10.
    healthy_threshold = var.health_check_healthy_threshold

    # The number of consecutive failed health checks required before considering a target unhealthy.
    # The range is 2–10.
    unhealthy_threshold = var.health_check_unhealthy_threshold

    # The amount of time, in seconds, during which no response from a target means a failed health check.
    # The range is 2–60 seconds.
    timeout = var.health_check_timeout

    # The approximate amount of time, in seconds, between health checks of an individual target.
    # The range is 5–300 seconds.
    interval = var.health_check_interval

    # The HTTP codes to use when checking for a successful response from a target.
    # You can specify multiple values (for example, "200,202") or a range of values (for example, "200-299").
    matcher = var.health_check_matcher

    # The protocol the load balancer uses when performing health checks on targets.
    # The possible protocols are HTTP and HTTPS.
    protocol = var.health_check_protocol
  }
}

# aws_lb_lister
resource "aws_lb_listener" "app-servers" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "8080"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-servers.arn
  }
}

# aws_lb_targe_group_attachment_app
resource "aws_lb_target_group_attachment" "app-1" {
  target_group_arn = aws_lb_target_group.app-servers.arn
  target_id        = aws_instance.app1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "app-2" {
  target_group_arn = aws_lb_target_group.app-servers.arn
  target_id        = aws_instance.app2.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "app-3" {
  target_group_arn = aws_lb_target_group.app-servers.arn
  target_id        = aws_instance.app3.id
  port             = 8080
}