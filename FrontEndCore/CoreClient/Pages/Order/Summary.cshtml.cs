using CoreClient.Extensions;
using CoreClient.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json;

namespace CoreClient.Pages.Order
{
  public class SummaryModel : PageModel
  {
    [BindProperty]
    public Customer Sender { get; set; }

    [BindProperty]
    public Customer Receiver { get; set; }

    [BindProperty]
    public PackageInfo PackageInfo { get; set; }

    public void OnGet()
    {
      Sender = TempData.GetWithKeep<Customer>("Sender");
      Receiver = TempData.GetWithKeep<Customer>("Receiver");
      PackageInfo = TempData.GetWithKeep<PackageInfo>("PackageInfo");
    }
  }
}