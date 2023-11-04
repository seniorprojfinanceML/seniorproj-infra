resource "aws_key_pair" "my_key_pair" {
  key_name   = "mlflow-test"
  public_key = file("D:\\year4\\project\\secure\\puttykey\\iseice.pub")
}
