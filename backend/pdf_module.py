from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, HRFlowable
from datetime import datetime
import os

def generate_complaint_pdf(report_data, output_path):

    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    doc = SimpleDocTemplate(
        output_path,
        pagesize=A4,
        rightMargin=inch,
        leftMargin=inch,
        topMargin=inch,
        bottomMargin=inch
    )

    styles = getSampleStyleSheet()

    title_style = ParagraphStyle(
        'TitleStyle',
        parent=styles['Title'],
        fontSize=20,
        textColor=colors.HexColor('#1a1a2e'),
        spaceAfter=6
    )

    subtitle_style = ParagraphStyle(
        'SubtitleStyle',
        parent=styles['Normal'],
        fontSize=11,
        textColor=colors.HexColor('#e94560'),
        spaceAfter=4
    )

    heading_style = ParagraphStyle(
        'HeadingStyle',
        parent=styles['Heading2'],
        fontSize=13,
        textColor=colors.HexColor('#1a1a2e'),
        spaceBefore=12,
        spaceAfter=6
    )

    normal_style = ParagraphStyle(
        'NormalStyle',
        parent=styles['Normal'],
        fontSize=10,
        textColor=colors.HexColor('#333333'),
        spaceAfter=4
    )

    elements = []

    # ─── Header ───────────────────────────────────────────────────────────────
    elements.append(Paragraph("ShieldNet", title_style))
    elements.append(Paragraph("Cyber Harassment Reporting Platform", subtitle_style))
    elements.append(Paragraph("DMCA Takedown Complaint", subtitle_style))
    elements.append(HRFlowable(width="100%", thickness=2, color=colors.HexColor('#e94560')))
    elements.append(Spacer(1, 0.2 * inch))

    # ─── Case Info ────────────────────────────────────────────────────────────
    elements.append(Paragraph("Case Information", heading_style))

    case_data = [
        ['Report ID', str(report_data.get('report_id', 'N/A'))],
        ['Case Token', str(report_data.get('token', 'N/A'))],
        ['Date Generated', datetime.utcnow().strftime('%Y-%m-%d %H:%M UTC')],
        ['Status', str(report_data.get('status', 'Pending'))],
        ['Platform', str(report_data.get('platform', 'N/A'))],
        ['Category', str(report_data.get('category', 'N/A'))],
        ['Country', str(report_data.get('country', 'N/A'))],
    ]

    case_table = Table(case_data, colWidths=[2 * inch, 4 * inch])
    case_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#f0f0f0')),
        ('TEXTCOLOR', (0, 0), (0, -1), colors.HexColor('#1a1a2e')),
        ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('ROWBACKGROUNDS', (1, 0), (1, -1), [colors.white, colors.HexColor('#f9f9f9')]),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor('#dddddd')),
        ('PADDING', (0, 0), (-1, -1), 6),
    ]))

    elements.append(case_table)
    elements.append(Spacer(1, 0.2 * inch))

    # ─── Incident Description ─────────────────────────────────────────────────
    elements.append(Paragraph("Incident Description", heading_style))
    elements.append(Paragraph(
        str(report_data.get('description', 'No description provided.')),
        normal_style
    ))
    elements.append(Spacer(1, 0.2 * inch))

    # ─── AI Analysis Results ──────────────────────────────────────────────────
    analysis_type = report_data.get('analysis_type')

    if analysis_type == 'image':
        elements.append(Paragraph("AI Analysis Results", heading_style))

        ai_data = [
            ['Analysis Type', 'Image Manipulation Detection'],
            ['Manipulation Score', f"{report_data.get('manipulation_score', 0)}%"],
            ['Verdict', str(report_data.get('verdict', 'N/A'))],
            ['Pixel Difference', str(report_data.get('pixel_difference', 'N/A'))],
        ]

        ai_table = Table(ai_data, colWidths=[2 * inch, 4 * inch])
        ai_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#f0f0f0')),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor('#dddddd')),
            ('PADDING', (0, 0), (-1, -1), 6),
        ]))

        elements.append(ai_table)
        elements.append(Spacer(1, 0.2 * inch))

    elif analysis_type == 'text':
        elements.append(Paragraph("AI Analysis Results", heading_style))

        ai_data = [
            ['Analysis Type', 'Text Harassment Detection'],
            ['Threat Score', f"{report_data.get('threat_score', 0)}%"],
            ['Verdict', str(report_data.get('verdict', 'N/A'))],
        ]

        ai_table = Table(ai_data, colWidths=[2 * inch, 4 * inch])
        ai_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#f0f0f0')),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor('#dddddd')),
            ('PADDING', (0, 0), (-1, -1), 6),
        ]))

        elements.append(ai_table)
        elements.append(Spacer(1, 0.2 * inch))

    # ─── DMCA Statement ───────────────────────────────────────────────────────
    elements.append(Paragraph("DMCA Takedown Statement", heading_style))
    elements.append(Paragraph(
        "I hereby request the immediate removal of the content described above "
        "from the specified platform. The content violates my rights and constitutes "
        "cyber harassment. This complaint has been filed through ShieldNet, a cyber "
        "harassment reporting and protection platform. All evidence has been verified "
        "through AI-assisted analysis.",
        normal_style
    ))
    elements.append(Spacer(1, 0.2 * inch))

    # ─── Footer ───────────────────────────────────────────────────────────────
    elements.append(HRFlowable(width="100%", thickness=1, color=colors.HexColor('#dddddd')))
    elements.append(Spacer(1, 0.1 * inch))
    elements.append(Paragraph(
        f"Generated by ShieldNet — University of Lahore IET | {datetime.utcnow().strftime('%Y-%m-%d')}",
        ParagraphStyle('Footer', parent=styles['Normal'], fontSize=8,
                       textColor=colors.grey, alignment=1)
    ))

    doc.build(elements)
    return output_path