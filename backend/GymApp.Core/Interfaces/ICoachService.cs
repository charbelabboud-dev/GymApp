using System.Collections.Generic;
using System.Threading.Tasks;
using GymApp.Core.DTOs;

namespace GymApp.Core.Interfaces
{
    public interface ICoachService
    {
        Task<List<CoachDto>> GetAllCoachesAsync();
        
        Task<List<CoachDto>> GetCoachesBySpecialtyAsync(string specialty);
    }
}