using System.Threading.Tasks;
using CoreClient.Extensions;
using CoreClient.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json;

namespace CoreClient.Pages.Order
{
  public class PackageModel : PageModel
  {
    [BindProperty]
    public PackageInfo PackageInfo { get; set; }

    public void OnGet()
    {
      PackageInfo = TempData.GetWithKeep<PackageInfo>("PackageInfo") ?? new PackageInfo();
    }

    public async Task<IActionResult> OnPostAsync()
    {
      TempData.Put("PackageInfo", PackageInfo);
      return RedirectToPage("/Order/Summary");
    }
  }
}