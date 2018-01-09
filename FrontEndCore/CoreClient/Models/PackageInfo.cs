using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CoreClient.Models
{
  public class PackageInfo
  {
    public string ShippingType { get; set; }
    public int Amount { get; set; }
    public string Weight { get; set; }
    public string Comments { get; set; }
  }
}