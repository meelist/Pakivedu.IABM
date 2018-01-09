using System.Threading.Tasks;
using CoreClient.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json;

namespace CoreClient.Pages.Order
{
  public class PackageModel : PageModel
  {
    [BindProperty]
    public Customer Sender { get; set; }
    [BindProperty]
    public Customer Receiver { get; set; }
    [BindProperty]
    public PackageInfo PackageInfo { get; set; }

    public void OnGet()
    {
      Sender = JsonConvert.DeserializeObject<Customer>(TempData["Sender"] as string);
      Receiver = JsonConvert.DeserializeObject<Customer>(TempData["Receiver"] as string);
      PackageInfo = new PackageInfo();
    }

    public async Task<IActionResult> OnPostAsync()
    {
      var senderJson = JsonConvert.SerializeObject(Sender);
      TempData["Sender"] = senderJson;
      var receiverJson = JsonConvert.SerializeObject(Receiver);
      TempData["Receiver"] = receiverJson;
      var packageInfoJson = JsonConvert.SerializeObject(PackageInfo);
      TempData["PackageInfo"] = packageInfoJson;
      return RedirectToPage("/Order/Summary");
    }
  }
}