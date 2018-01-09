using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Client.Models
{
  public class Customer
  {
    public string CustomerName { get; set; }
    public string Telephone { get; set; }
    public string Address { get; set; }
    public string Email { get; set; }
    public string Password { get; set; }
    public string ZipCode { get; set; }
    public string Country { get; set; }
    public string UserName { get; set; }
    public int CompanyKey { get; set; }
  }
}