module "vpc" {
  source = "./modules"

  vpc_name = local.vpc.name
  vpc_cidr = local.vpc.cidr

  public_subnet_a_name = "public-a"
  public_subnet_a_cidr = "10.0.4.0/24"

  public_subnet_b_name = "public-b"
  public_subnet_b_cidr = "10.0.5.0/24"

  public_subnet_c_name = "public-c"
  public_subnet_c_cidr = "10.0.6.0/24"

  private_subnet_a_name =  "private-a"
  private_subnet_a_cidr = "10.0.1.0/24"

  private_subnet_b_name =  "private-b"
  private_subnet_b_cidr = "10.0.2.0/24"

  private_subnet_c_name =  "private-c"
  private_subnet_c_cidr = "10.0.3.0/24"

  igw_name = "jnc-igw"

  nat_a_name = "jnc-ngw-a"
  nat_b_name = "jnc-ngw-b"
  nat_c_name = "jnc-ngw-c"

  public_rt_name = "public-rt"
  private_a_rt_name = "private-rt-a"
  private_b_rt_name = "private-rt-b"
  private_c_rt_name = "private-rt-c"
}