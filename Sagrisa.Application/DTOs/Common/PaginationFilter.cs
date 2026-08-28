namespace Sagrisa.Application.DTOs.Common
{
    public class PaginationFilter
    {
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 20;
        public string? Query { get; set; }

        public PaginationFilter() { }

        public PaginationFilter(int pageNumber, int pageSize, string? query = null)
        {
            PageNumber = pageNumber < 1 ? 1 : pageNumber;
            PageSize = pageSize > 100 ? 100 : (pageSize < 1 ? 20 : pageSize);
            Query = query;
        }
    }
}
