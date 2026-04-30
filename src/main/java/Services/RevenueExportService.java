package Services;

import java.io.OutputStream;
import java.util.List;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.FillPatternType;
// --- ❌ XÓA DÒNG NÀY: import java.awt.Font; ---
// --- ✅ THAY BẰNG DÒNG DƯỚI ĐÂY: ---
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import Entities.User;

public class RevenueExportService {

    public static void exportRevenueReport(OutputStream outputStream) throws Exception {

        // 1. Khởi tạo Workbook và Sheet
        XSSFWorkbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("BaoCaoDongTien");

        // 2. Định dạng (Styles)
        CellStyle headerStyle = createHeaderStyle(workbook, IndexedColors.DARK_GREEN.getIndex());
        CellStyle subHeaderStyle = createHeaderStyle(workbook, IndexedColors.GREY_25_PERCENT.getIndex());
        CellStyle currencyStyle = createCurrencyStyle(workbook);
        CellStyle defaultStyle = createDefaultStyle(workbook);

        // --- LẤY DỮ LIỆU ĐỂ BÁO CÁO ---
        long totalRevenue = Services.RevenueService.getTotalRevenue();
        int viewRate = Services.RevenueService.getViewRate();
        List<Object[]> editorStats = Services.RevenueService.getEditorRevenueStats();

        long totalExpense = editorStats.stream().mapToLong(row -> (Long) row[2]).sum();
        long netProfit = totalRevenue - totalExpense;


        // ==========================================================
        // KHỐI 1: HEADER BÁO CÁO
        // ==========================================================
        int rowNum = 0;

        Row titleRow = sheet.createRow(rowNum++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("BÁO CÁO QUẢN LÝ DÒNG TIỀN VÀ CHI PHÍ (DÂN TRÍ)");
        titleCell.setCellStyle(createTitleStyle(workbook));
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 4)); // Merge cell A1 đến E1

        sheet.createRow(rowNum++).createCell(0).setCellValue("Ngày xuất báo cáo: " + new java.util.Date());
        rowNum++; // Khoảng trống

        // ==========================================================
        // KHỐI 2: TỔNG QUAN TÀI CHÍNH
        // ==========================================================

        Row sumHeaderRow = sheet.createRow(rowNum++);
        sumHeaderRow.createCell(0).setCellValue("TỔNG QUAN TÀI CHÍNH");
        sumHeaderRow.getCell(0).setCellStyle(subHeaderStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum - 1, rowNum - 1, 0, 1));

        // Dòng Tổng Doanh Thu
        Row row1 = sheet.createRow(rowNum++);
        row1.createCell(0).setCellValue("Tổng Doanh Thu (VNPay)");
        row1.getCell(0).setCellStyle(defaultStyle);
        row1.createCell(1).setCellValue(totalRevenue);
        row1.getCell(1).setCellStyle(currencyStyle);

        // Dòng Tổng Chi Phí
        Row row2 = sheet.createRow(rowNum++);
        row2.createCell(0).setCellValue("Tổng Chi Phí (Trả Editor)");
        row2.getCell(0).setCellStyle(defaultStyle);
        row2.createCell(1).setCellValue(totalExpense);
        row2.getCell(1).setCellStyle(currencyStyle);

        // Dòng Lợi Nhuận Ròng
        Row row3 = sheet.createRow(rowNum++);
        row3.createCell(0).setCellValue("Lợi Nhuận Ròng (Net Profit)");
        row3.getCell(0).setCellStyle(headerStyle);
        row3.createCell(1).setCellValue(netProfit);
        row3.getCell(1).setCellStyle(headerStyle);

        rowNum++; // Khoảng trống


        // ==========================================================
        // KHỐI 3: BÁO CÁO LƯƠNG EDITOR (CHI TIẾT CHI PHÍ)
        // ==========================================================

        Row editorHeaderRow = sheet.createRow(rowNum++);
        editorHeaderRow.createCell(0).setCellValue("CHI TIẾT CHI PHÍ: LƯƠNG CỘNG TÁC VIÊN (VIEW RATE: " + viewRate + " VNĐ/VIEW)");
        editorHeaderRow.getCell(0).setCellStyle(subHeaderStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum - 1, rowNum - 1, 0, 4));

        // Bảng chi tiết
        Row detailHeader = sheet.createRow(rowNum++);
        String[] detailHeaders = {"ID", "Tên Editor", "Username", "Tổng View", "Thanh Toán"};
        for (int i = 0; i < detailHeaders.length; i++) {
            Cell cell = detailHeader.createCell(i);
            cell.setCellValue(detailHeaders[i]);
            cell.setCellStyle(headerStyle);
        }

        // Ghi dữ liệu chi tiết
        for (Object[] rowData : editorStats) {
            Row row = sheet.createRow(rowNum++);
            User user = (User) rowData[0];
            Long views = (Long) rowData[1];
            Long earnings = (Long) rowData[2];

            row.createCell(0).setCellValue(user.getId());
            row.createCell(1).setCellValue(user.getName());
            row.createCell(2).setCellValue(user.getUsername());
            row.createCell(3).setCellValue(views);
            row.createCell(4).setCellValue(earnings);

            // Định dạng tiền tệ cho cột Thanh Toán
            row.getCell(4).setCellStyle(currencyStyle);
        }

        // 5. Tự động điều chỉnh độ rộng cột
        for (int i = 0; i < 5; i++) {
            sheet.autoSizeColumn(i);
        }

        // 6. Ghi Workbook ra OutputStream
        workbook.write(outputStream);
        workbook.close();
    }

    // --- HÀM TẠO STYLE ---

    private static CellStyle createHeaderStyle(Workbook workbook, short color) {
        CellStyle style = workbook.createCellStyle();
        style.setFillForegroundColor(color);
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);

        Font font = workbook.createFont();
        font.setBold(true);
        if (color == IndexedColors.DARK_GREEN.getIndex()) {
             font.setColor(IndexedColors.WHITE.getIndex());
        }
        style.setFont(font);
        return style;
    }

    private static CellStyle createTitleStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 16);
        style.setFont(font);
        return style;
    }

    private static CellStyle createDefaultStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    private static CellStyle createCurrencyStyle(Workbook workbook) {
        CellStyle style = createDefaultStyle(workbook);
        // Định dạng tiền tệ Việt Nam
        DataFormat format = workbook.createDataFormat();
        style.setDataFormat(format.getFormat("#,##0 \\VNĐ"));
        return style;
    }
}