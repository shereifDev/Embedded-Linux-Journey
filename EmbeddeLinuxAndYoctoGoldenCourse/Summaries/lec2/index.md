<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Embedded Linux & Yocto — الدرس الثاني: Linux Architecture in Details</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans+Arabic:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
/* ═══════════════════════════════════════════════════════
   CSS CUSTOM PROPERTIES — PROFESSIONAL COLOR SYSTEM
   ═══════════════════════════════════════════════════════ */
:root {
  --primary: #0F4C81;
  --primary-light: #1a6bb5;
  --primary-dark: #0a3559;
  --primary-bg: #e8f0fe;
  --secondary: #14B8A6;
  --secondary-light: #2dd4bf;
  --secondary-bg: #e6f9f7;
  --accent: #F59E0B;
  --accent-light: #fbbf24;
  --accent-bg: #fff8e1;
  --success: #16A34A;
  --success-light: #22c55e;
  --success-bg: #e8f9ee;
  --warning: #EA580C;
  --warning-light: #f97316;
  --warning-bg: #fff1e6;
  --danger: #DC2626;
  --danger-light: #ef4444;
  --danger-bg: #fee8e8;
  --purple: #7C3AED;
  --purple-light: #8b5cf6;
  --purple-bg: #f0eaff;
  --dark-bg: #1e293b;
  --dark-surface: #334155;
  --dark-text: #f1f5f9;
  --bg: #F8FAFC;
  --white: #FFFFFF;
  --gray-50: #f8fafc;
  --gray-100: #f1f5f9;
  --gray-200: #e2e8f0;
  --gray-300: #cbd5e1;
  --gray-400: #94a3b8;
  --gray-500: #64748b;
  --gray-600: #475569;
  --gray-700: #334155;
  --gray-800: #1e293b;
  --gray-900: #0f172a;
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow: 0 1px 3px rgba(0,0,0,0.1), 0 1px 2px rgba(0,0,0,0.06);
  --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06);
  --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -2px rgba(0,0,0,0.05);
  --shadow-xl: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);
  --radius-sm: 6px;
  --radius: 10px;
  --radius-lg: 14px;
  --radius-xl: 20px;
}

/* ═══════════════════════════════════════════════════════
   RESET & BASE
   ═══════════════════════════════════════════════════════ */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

html {
  font-size: 12.5pt;
  scroll-behavior: smooth;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

body {
  font-family: 'IBM Plex Sans Arabic', 'Cairo', 'Noto Sans Arabic', sans-serif;
  background: var(--bg);
  color: var(--gray-800);
  line-height: 1.7;
  direction: rtl;
  text-align: justify;
}

/* ═══════════════════════════════════════════════════════
   PAGE CONTAINER — A4 SIMULATION
   ═══════════════════════════════════════════════════════ */
.page {
  width: 210mm;
  min-height: 297mm;
  margin: 20px auto;
  background: var(--white);
  box-shadow: var(--shadow-xl);
  padding: 2cm;
  position: relative;
  overflow: hidden;
}

/* ═══════════════════════════════════════════════════════
   HEADER & FOOTER
   ═══════════════════════════════════════════════════════ */
.page-header {
  position: absolute;
  top: 0;
  right: 2cm;
  left: 2cm;
  height: 1cm;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1.5px solid var(--gray-200);
  padding-bottom: 4px;
  font-size: 8.5pt;
  color: var(--gray-400);
  font-family: 'IBM Plex Sans Arabic', sans-serif;
  direction: rtl;
}

.page-header .course-name {
  font-weight: 600;
  color: var(--primary);
}

.page-header .chapter-name {
  font-weight: 500;
}

.page-footer {
  position: absolute;
  bottom: 0;
  right: 2cm;
  left: 2cm;
  height: 1cm;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-top: 1.5px solid var(--gray-200);
  padding-top: 4px;
  font-size: 8.5pt;
  color: var(--gray-400);
  font-family: 'IBM Plex Sans Arabic', sans-serif;
  direction: rtl;
}

.page-footer .page-num {
  font-weight: 700;
  color: var(--primary);
  font-family: 'Inter', sans-serif;
  direction: ltr;
}

.page-content {
  padding-top: 1.2cm;
  padding-bottom: 1.2cm;
}

/* ═══════════════════════════════════════════════════════
   TABLE OF CONTENTS
   ═══════════════════════════════════════════════════════ */
.toc-container {
  padding: 0;
}

.toc-title {
  font-size: 28pt;
  font-weight: 800;
  color: var(--primary);
  margin-bottom: 8px;
  letter-spacing: -0.5px;
}

.toc-subtitle {
  font-size: 13pt;
  color: var(--gray-500);
  margin-bottom: 30px;
  font-weight: 400;
}

.toc-divider {
  width: 80px;
  height: 4px;
  background: linear-gradient(90deg, var(--primary), var(--secondary));
  border-radius: 4px;
  margin-bottom: 30px;
}

.toc-list {
  list-style: none;
  padding: 0;
}

.toc-item {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  padding: 10px 0;
  border-bottom: 1px dotted var(--gray-200);
  text-decoration: none;
  color: var(--gray-700);
  transition: all 0.2s ease;
  cursor: pointer;
}

.toc-item:hover {
  color: var(--primary);
  background: var(--primary-bg);
  padding-right: 12px;
  padding-left: 12px;
  border-radius: var(--radius-sm);
}

.toc-item.main {
  font-weight: 700;
  font-size: 12pt;
  color: var(--primary-dark);
  border-bottom: 1px solid var(--gray-200);
  padding-top: 14px;
  padding-bottom: 14px;
}

.toc-item.main:hover {
  background: var(--primary-bg);
}

.toc-item.sub {
  padding-right: 24px;
  font-size: 11pt;
  font-weight: 500;
}

.toc-item.subsub {
  padding-right: 48px;
  font-size: 10.5pt;
  font-weight: 400;
  color: var(--gray-600);
}

.toc-number {
  font-family: 'Inter', sans-serif;
  font-weight: 700;
  color: var(--primary);
  margin-left: 10px;
  direction: ltr;
  white-space: nowrap;
}

.toc-page {
  font-family: 'Inter', sans-serif;
  font-weight: 600;
  color: var(--gray-400);
  direction: ltr;
  white-space: nowrap;
  min-width: 30px;
  text-align: left;
}

/* ═══════════════════════════════════════════════════════
   CHAPTER OPENING
   ═══════════════════════════════════════════════════════ */
.chapter-opening {
  text-align: center;
  margin-bottom: 40px;
  padding: 30px 0 20px;
}

.chapter-number {
  display: inline-block;
  font-family: 'Inter', sans-serif;
  font-size: 14pt;
  font-weight: 700;
  color: var(--secondary);
  letter-spacing: 3px;
  text-transform: uppercase;
  direction: ltr;
  margin-bottom: 10px;
}

.chapter-icon {
  width: 70px;
  height: 70px;
  margin: 0 auto 16px;
  background: linear-gradient(135deg, var(--primary), var(--primary-light));
  border-radius: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8px 25px rgba(15,76,129,0.3);
}

.chapter-icon svg {
  width: 36px;
  height: 36px;
  fill: white;
}

.chapter-title {
  font-size: 24pt;
  font-weight: 800;
  color: var(--primary);
  margin-bottom: 8px;
  line-height: 1.3;
}

.chapter-subtitle {
  font-size: 13pt;
  color: var(--gray-500);
  font-weight: 400;
  margin-bottom: 20px;
}

.chapter-divider {
  width: 120px;
  height: 4px;
  background: linear-gradient(90deg, var(--primary), var(--secondary), var(--accent));
  border-radius: 4px;
  margin: 0 auto 20px;
}

.chapter-intro {
  font-size: 11.5pt;
  color: var(--gray-600);
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.8;
}

.trainer-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: var(--gray-100);
  padding: 6px 18px;
  border-radius: 30px;
  font-size: 10pt;
  color: var(--gray-600);
  margin-bottom: 20px;
  direction: rtl;
}

.trainer-badge .trainer-icon {
  width: 24px;
  height: 24px;
  background: var(--primary);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.trainer-badge .trainer-icon svg {
  width: 14px;
  height: 14px;
  fill: white;
}

/* ═══════════════════════════════════════════════════════
   ANIMATED CHAPTER OVERVIEW — ROADMAP
   ═══════════════════════════════════════════════════════ */
.overview-container {
  background: linear-gradient(135deg, #f0f7ff 0%, #f5fffe 100%);
  border: 1.5px solid var(--gray-200);
  border-radius: var(--radius-xl);
  padding: 28px;
  margin-bottom: 36px;
  position: relative;
  overflow: hidden;
}

.overview-container::before {
  content: '';
  position: absolute;
  top: -40px;
  left: -40px;
  width: 150px;
  height: 150px;
  background: radial-gradient(circle, rgba(20,184,166,0.08) 0%, transparent 70%);
  border-radius: 50%;
}

.overview-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 10pt;
  font-weight: 700;
  color: var(--secondary);
  text-transform: uppercase;
  letter-spacing: 1.5px;
  margin-bottom: 20px;
  direction: rtl;
}

.overview-label svg {
  width: 18px;
  height: 18px;
}

.roadmap {
  display: flex;
  flex-direction: row-reverse;
  gap: 0;
  position: relative;
  justify-content: center;
  flex-wrap: wrap;
}

.roadmap-step {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  width: 110px;
  position: relative;
}

.roadmap-step-icon {
  width: 52px;
  height: 52px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 8px;
  box-shadow: var(--shadow-md);
  position: relative;
  z-index: 2;
}

.roadmap-step-icon svg {
  width: 26px;
  height: 26px;
}

.roadmap-step-num {
  font-family: 'Inter', sans-serif;
  font-size: 8pt;
  font-weight: 700;
  color: white;
  position: absolute;
  top: -5px;
  right: -5px;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 3;
  direction: ltr;
}

.roadmap-step-title {
  font-size: 9pt;
  font-weight: 700;
  color: var(--gray-800);
  margin-bottom: 3px;
  line-height: 1.4;
}

.roadmap-step-desc {
  font-size: 7.5pt;
  color: var(--gray-500);
  line-height: 1.4;
}

.roadmap-arrow {
  display: flex;
  align-items: center;
  color: var(--gray-300);
  margin: 0 -4px;
  margin-bottom: 30px;
  z-index: 1;
}

.roadmap-arrow svg {
  width: 24px;
  height: 24px;
}

/* Step colors */
.step-blue .roadmap-step-icon { background: linear-gradient(135deg, var(--primary), var(--primary-light)); }
.step-blue .roadmap-step-num { background: var(--primary-dark); }
.step-teal .roadmap-step-icon { background: linear-gradient(135deg, var(--secondary), var(--secondary-light)); }
.step-teal .roadmap-step-num { background: #0d9488; }
.step-orange .roadmap-step-icon { background: linear-gradient(135deg, var(--accent), var(--accent-light)); }
.step-orange .roadmap-step-num { background: #d97706; }
.step-green .roadmap-step-icon { background: linear-gradient(135deg, var(--success), var(--success-light)); }
.step-green .roadmap-step-num { background: #15803d; }
.step-purple .roadmap-step-icon { background: linear-gradient(135deg, var(--purple), var(--purple-light)); }
.step-purple .roadmap-step-num { background: #6d28d9; }
.step-red .roadmap-step-icon { background: linear-gradient(135deg, var(--danger), var(--danger-light)); }
.step-red .roadmap-step-num { background: #b91c1c; }
.step-gray .roadmap-step-icon { background: linear-gradient(135deg, var(--gray-600), var(--gray-500)); }
.step-gray .roadmap-step-num { background: var(--gray-700); }

/* ═══════════════════════════════════════════════════════
   SECTION HEADINGS
   ═══════════════════════════════════════════════════════ */
.section {
  margin-bottom: 30px;
}

.section-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
  padding-bottom: 10px;
  border-bottom: 2.5px solid var(--primary);
}

.section-number {
  font-family: 'Inter', sans-serif;
  font-size: 12pt;
  font-weight: 800;
  color: var(--white);
  background: var(--primary);
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  direction: ltr;
  flex-shrink: 0;
}

.section-title {
  font-size: 20pt;
  font-weight: 800;
  color: var(--primary);
  line-height: 1.3;
}

.subsection {
  margin-bottom: 20px;
  margin-top: 24px;
}

.subsection-title {
  font-size: 17pt;
  font-weight: 700;
  color: var(--gray-800);
  margin-bottom: 12px;
  padding-right: 14px;
  border-right: 4px solid var(--secondary);
  line-height: 1.4;
}

.subsubsection-title {
  font-size: 14pt;
  font-weight: 600;
  color: var(--gray-700);
  margin-bottom: 10px;
  margin-top: 16px;
}

/* ═══════════════════════════════════════════════════════
   BODY TEXT & PARAGRAPHS
   ═══════════════════════════════════════════════════════ */
p {
  margin-bottom: 12px;
  line-height: 1.75;
  text-align: justify;
}

strong, b {
  font-weight: 700;
  color: var(--gray-900);
}

/* English terms inline */
.en-term {
  font-family: 'Inter', sans-serif;
  direction: ltr;
  unicode-bidi: embed;
  font-weight: 600;
  color: var(--primary);
  font-size: 0.95em;
}

/* ═══════════════════════════════════════════════════════
   CALLOUT BOXES
   ═══════════════════════════════════════════════════════ */
.callout {
  border-radius: var(--radius-lg);
  margin: 18px 0;
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  border: 1px solid transparent;
}

.callout-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 18px;
  font-weight: 700;
  font-size: 11pt;
}

.callout-body {
  padding: 14px 18px 16px;
  font-size: 11pt;
  line-height: 1.75;
}

.callout-body p { margin-bottom: 8px; }
.callout-body p:last-child { margin-bottom: 0; }

/* Blue — Concept */
.callout-blue {
  background: var(--primary-bg);
  border-color: rgba(15,76,129,0.15);
}
.callout-blue .callout-header {
  background: var(--primary);
  color: white;
}
.callout-blue .callout-body {
  color: var(--gray-800);
}

/* Green — Key Takeaway */
.callout-green {
  background: var(--success-bg);
  border-color: rgba(22,163,74,0.15);
}
.callout-green .callout-header {
  background: var(--success);
  color: white;
}
.callout-green .callout-body {
  color: var(--gray-800);
}

/* Orange — Tip */
.callout-orange {
  background: var(--accent-bg);
  border-color: rgba(245,158,11,0.15);
}
.callout-orange .callout-header {
  background: var(--accent);
  color: white;
}
.callout-orange .callout-body {
  color: var(--gray-800);
}

/* Red — Important/Warning */
.callout-red {
  background: var(--danger-bg);
  border-color: rgba(220,38,38,0.15);
}
.callout-red .callout-header {
  background: var(--danger);
  color: white;
}
.callout-red .callout-body {
  color: var(--gray-800);
}

/* Gray — Definition */
.callout-gray {
  background: var(--gray-100);
  border-color: var(--gray-300);
}
.callout-gray .callout-header {
  background: var(--gray-700);
  color: white;
}
.callout-gray .callout-body {
  color: var(--gray-800);
}

/* Purple — Deep Understanding */
.callout-purple {
  background: var(--purple-bg);
  border-color: rgba(124,58,237,0.15);
}
.callout-purple .callout-header {
  background: var(--purple);
  color: white;
}
.callout-purple .callout-body {
  color: var(--gray-800);
}

/* Dark — Practical Example */
.callout-dark {
  background: var(--dark-bg);
  border-color: var(--dark-surface);
}
.callout-dark .callout-header {
  background: var(--dark-surface);
  color: var(--dark-text);
}
.callout-dark .callout-body {
  color: var(--gray-300);
}

.callout-icon {
  width: 22px;
  height: 22px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14pt;
  line-height: 1;
}

/* ═══════════════════════════════════════════════════════
   LISTS
   ═══════════════════════════════════════════════════════ */
ul, ol {
  padding-right: 24px;
  margin-bottom: 14px;
}

ul { list-style: none; padding-right: 8px; }

ul li {
  position: relative;
  padding-right: 20px;
  margin-bottom: 8px;
  line-height: 1.75;
}

ul li::before {
  content: '';
  position: absolute;
  right: 0;
  top: 10px;
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: var(--secondary);
}

ul.primary-bullets li::before { background: var(--primary); }
ul.accent-bullets li::before { background: var(--accent); }
ul.danger-bullets li::before { background: var(--danger); }

ol {
  counter-reset: arabic-counter;
}

ol li {
  position: relative;
  padding-right: 32px;
  margin-bottom: 8px;
  line-height: 1.75;
}

ol li::before {
  counter-increment: arabic-counter;
  content: counter(arabic-counter);
  position: absolute;
  right: 0;
  top: 2px;
  width: 24px;
  height: 24px;
  border-radius: 8px;
  background: var(--primary);
  color: white;
  font-family: 'Inter', sans-serif;
  font-size: 10pt;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  direction: ltr;
}

/* ═══════════════════════════════════════════════════════
   TABLES
   ═══════════════════════════════════════════════════════ */
.table-wrapper {
  margin: 20px 0;
  overflow-x: auto;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow);
  border: 1px solid var(--gray-200);
}

table {
  width: 100%;
  border-collapse: collapse;
  font-size: 10.5pt;
}

thead th {
  background: var(--primary);
  color: white;
  font-weight: 700;
  padding: 12px 16px;
  text-align: right;
  white-space: nowrap;
  font-size: 10.5pt;
}

thead th:first-child {
  border-radius: 0 var(--radius-lg) 0 0;
}

thead th:last-child {
  border-radius: var(--radius-lg) 0 0 0;
}

tbody td {
  padding: 10px 16px;
  border-bottom: 1px solid var(--gray-100);
  vertical-align: top;
  line-height: 1.65;
}

tbody tr:nth-child(even) {
  background: var(--gray-50);
}

tbody tr:last-child td:first-child {
  border-radius: 0 var(--radius-lg) 0 0;
}

tbody tr:last-child td:last-child {
  border-radius: var(--radius-lg) 0 0 0;
}

td.num-cell {
  text-align: center;
  font-family: 'Inter', sans-serif;
  direction: ltr;
  font-weight: 600;
}

td.en-cell {
  direction: ltr;
  text-align: left;
  font-family: 'Inter', sans-serif;
  font-weight: 500;
}

/* Comparison table */
table.comparison thead th {
  background: var(--primary-dark);
}

table.comparison tbody td:first-child {
  background: var(--primary-bg);
  font-weight: 700;
  color: var(--primary-dark);
}

/* ═══════════════════════════════════════════════════════
   CODE BLOCKS
   ═══════════════════════════════════════════════════════ */
.code-block {
  background: #1e293b;
  border-radius: var(--radius-lg);
  margin: 16px 0;
  overflow: hidden;
  box-shadow: var(--shadow-md);
  border: 1px solid var(--dark-surface);
  direction: ltr;
  text-align: left;
}

.code-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 16px;
  background: var(--dark-surface);
  border-bottom: 1px solid rgba(255,255,255,0.06);
}

.code-lang {
  font-family: 'Inter', sans-serif;
  font-size: 9pt;
  font-weight: 600;
  color: var(--secondary);
  text-transform: uppercase;
  letter-spacing: 1px;
}

.code-dots {
  display: flex;
  gap: 6px;
}

.code-dots span {
  width: 10px;
  height: 10px;
  border-radius: 50%;
}

.code-dots span:nth-child(1) { background: #ef4444; }
.code-dots span:nth-child(2) { background: #f59e0b; }
.code-dots span:nth-child(3) { background: #22c55e; }

.code-body {
  padding: 16px 20px;
  overflow-x: auto;
  font-family: 'JetBrains Mono', monospace;
  font-size: 10pt;
  line-height: 1.7;
  color: #e2e8f0;
  direction: ltr;
  text-align: left;
  white-space: pre;
}

.code-body .kw { color: #c084fc; }
.code-body .fn { color: #60a5fa; }
.code-body .str { color: #34d399; }
.code-body .cmt { color: #64748b; font-style: italic; }
.code-body .num { color: #fbbf24; }
.code-body .reg { color: #f472b6; }
.code-body .op { color: #94a3b8; }

/* Inline code */
code {
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.88em;
  background: var(--gray-100);
  color: var(--primary-dark);
  padding: 2px 7px;
  border-radius: 5px;
  direction: ltr;
  unicode-bidi: embed;
  border: 1px solid var(--gray-200);
}

/* ═══════════════════════════════════════════════════════
   TECHNICAL DIAGRAMS
   ═══════════════════════════════════════════════════════ */
.diagram-container {
  margin: 24px 0;
  padding: 24px;
  background: var(--white);
  border: 1.5px solid var(--gray-200);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow);
}

.diagram-title {
  font-size: 11pt;
  font-weight: 700;
  color: var(--gray-600);
  text-align: center;
  margin-bottom: 20px;
  direction: rtl;
}

.diagram {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0;
  direction: ltr;
}

.diagram-layer {
  width: 100%;
  max-width: 420px;
  padding: 16px 20px;
  border-radius: var(--radius);
  text-align: center;
  font-weight: 700;
  font-size: 11.5pt;
  position: relative;
  font-family: 'Inter', 'IBM Plex Sans Arabic', sans-serif;
}

.diagram-layer.en { direction: ltr; }

.diagram-arrow {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 32px;
  color: var(--gray-400);
}

.diagram-arrow svg {
  width: 24px;
  height: 24px;
}

.layer-user { background: linear-gradient(135deg, #dbeafe, #eff6ff); color: var(--primary-dark); border: 1.5px solid #93c5fd; }
.layer-syscall { background: linear-gradient(135deg, #fef3c7, #fffbeb); color: #92400e; border: 1.5px solid #fcd34d; font-size: 10.5pt; }
.layer-kernel { background: linear-gradient(135deg, #d1fae5, #ecfdf5); color: #065f46; border: 1.5px solid #6ee7b7; }
.layer-hw { background: linear-gradient(135deg, #e0e7ff, #eef2ff); color: #3730a3; border: 1.5px solid #a5b4fc; }

/* Exception Levels Diagram */
.el-diagram {
  display: flex;
  flex-direction: column;
  gap: 6px;
  width: 100%;
  max-width: 480px;
  direction: ltr;
}

.el-level {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 18px;
  border-radius: var(--radius);
  font-family: 'Inter', 'IBM Plex Sans Arabic', sans-serif;
}

.el-badge {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 800;
  font-size: 13pt;
  color: white;
  flex-shrink: 0;
  direction: ltr;
}

.el-info { flex: 1; }
.el-name { font-weight: 700; font-size: 11pt; color: var(--gray-800); }
.el-desc { font-size: 9.5pt; color: var(--gray-500); line-height: 1.5; }

.el-0 .el-badge { background: var(--gray-500); }
.el-0 { background: var(--gray-100); }
.el-1 .el-badge { background: var(--primary); }
.el-1 { background: var(--primary-bg); }
.el-2 .el-badge { background: var(--secondary); }
.el-2 { background: var(--secondary-bg); }
.el-3 .el-badge { background: var(--danger); }
.el-3 { background: var(--danger-bg); }

/* Syscall Flow Diagram */
.syscall-flow {
  display: flex;
  flex-direction: column;
  gap: 0;
  align-items: center;
  direction: ltr;
  width: 100%;
}

.sf-step {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
  max-width: 460px;
}

.sf-num {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--primary);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: 'Inter', sans-serif;
  font-weight: 700;
  font-size: 11pt;
  flex-shrink: 0;
}

.sf-content {
  flex: 1;
  padding: 10px 16px;
  background: var(--gray-50);
  border: 1px solid var(--gray-200);
  border-radius: var(--radius);
  font-size: 10pt;
  line-height: 1.6;
  color: var(--gray-700);
  font-family: 'Inter', 'IBM Plex Sans Arabic', sans-serif;
}

.sf-arrow-down {
  width: 2px;
  height: 14px;
  background: var(--gray-300);
  margin-right: 15px;
}

/* Process Creation Flow */
.process-flow {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0;
  direction: ltr;
  width: 100%;
}

.pf-box {
  padding: 12px 24px;
  border-radius: var(--radius);
  text-align: center;
  font-weight: 600;
  font-size: 10.5pt;
  font-family: 'Inter', 'IBM Plex Sans Arabic', sans-serif;
  min-width: 260px;
  max-width: 360px;
}

.pf-arrow {
  display: flex;
  flex-direction: column;
  align-items: center;
  height: 28px;
  color: var(--gray-400);
}

.pf-arrow svg { width: 20px; height: 20px; }

.pf-storage { background: #e0e7ff; color: #3730a3; border: 1.5px solid #a5b4fc; }
.pf-userspace { background: #dbeafe; color: #1e40af; border: 1.5px solid #93c5fd; }
.pf-kernel { background: #d1fae5; color: #065f46; border: 1.5px solid #6ee7b7; }
.pf-scheduler { background: #fef3c7; color: #92400e; border: 1.5px solid #fcd34d; }

/* ═══════════════════════════════════════════════════════
   QUICK REVIEW SECTION
   ═══════════════════════════════════════════════════════ */
.quick-review {
  margin-top: 36px;
  padding: 28px;
  background: linear-gradient(135deg, #f8fafc, #f1f5f9);
  border: 2px solid var(--gray-200);
  border-radius: var(--radius-xl);
  position: relative;
}

.quick-review-title {
  font-size: 20pt;
  font-weight: 800;
  color: var(--primary);
  margin-bottom: 24px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.quick-review-title svg {
  width: 28px;
  height: 28px;
}

.qr-section {
  margin-bottom: 22px;
}

.qr-section-title {
  font-size: 13pt;
  font-weight: 700;
  color: var(--gray-800);
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  gap: 8px;
  padding-bottom: 6px;
  border-bottom: 1.5px solid var(--gray-200);
}

.qr-section-title .qr-icon {
  width: 24px;
  height: 24px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12pt;
  flex-shrink: 0;
}

.qr-list {
  list-style: none;
  padding: 0;
}

.qr-list li {
  padding-right: 28px;
  position: relative;
  margin-bottom: 6px;
  font-size: 10.5pt;
  line-height: 1.7;
}

.qr-list li::before {
  content: '✓';
  position: absolute;
  right: 0;
  top: 2px;
  color: var(--success);
  font-weight: 700;
  font-family: 'Inter', sans-serif;
}

.qr-list.warn li::before {
  content: '✗';
  color: var(--danger);
}

.qr-list.tip li::before {
  content: '★';
  color: var(--accent);
}

.qr-list.q li::before {
  content: '?';
  color: var(--primary);
  font-weight: 800;
}

/* Checklist */
.checklist {
  list-style: none;
  padding: 0;
}

.checklist li {
  padding: 8px 12px 8px 8px;
  margin-bottom: 4px;
  background: white;
  border: 1px solid var(--gray-200);
  border-radius: var(--radius-sm);
  font-size: 10.5pt;
  display: flex;
  align-items: center;
  gap: 10px;
  direction: rtl;
}

.checklist li .check-box {
  width: 20px;
  height: 20px;
  border: 2px solid var(--gray-300);
  border-radius: 5px;
  flex-shrink: 0;
}

/* ═══════════════════════════════════════════════════════
   MISC UTILITIES
   ═══════════════════════════════════════════════════════ */
.mb-0 { margin-bottom: 0 !important; }
.mb-sm { margin-bottom: 8px !important; }
.mb-md { margin-bottom: 16px !important; }
.mb-lg { margin-bottom: 24px !important; }
.mt-md { margin-top: 16px !important; }
.mt-lg { margin-top: 24px !important; }

.page-break {
  page-break-after: always;
  break-after: page;
  margin-bottom: 0;
}

.text-center { text-align: center; }

/* Quick flash review */
.flash-review {
  background: var(--dark-bg);
  color: var(--dark-text);
  border-radius: var(--radius-lg);
  padding: 18px 20px;
  margin: 16px 0;
  direction: rtl;
}

.flash-review .flash-title {
  font-size: 10pt;
  font-weight: 700;
  color: var(--accent);
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.flash-review ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.flash-review ul li {
  padding-right: 0;
  margin-bottom: 4px;
  font-size: 10.5pt;
  line-height: 1.6;
  color: var(--gray-300);
}

.flash-review ul li::before {
  content: '→';
  color: var(--secondary);
  margin-left: 8px;
  font-family: 'Inter', sans-serif;
}

.flash-review .en-term {
  color: var(--secondary-light);
}

/* Golden advice box */
.golden-advice {
  background: linear-gradient(135deg, #fffbeb, #fef3c7);
  border: 2px solid #fcd34d;
  border-radius: var(--radius-xl);
  padding: 20px 24px;
  margin: 20px 0;
  position: relative;
  overflow: hidden;
}

.golden-advice::before {
  content: '★';
  position: absolute;
  top: -10px;
  left: -5px;
  font-size: 60pt;
  color: rgba(252,211,77,0.15);
  transform: rotate(-15deg);
}

.golden-advice-title {
  font-size: 12pt;
  font-weight: 800;
  color: #92400e;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.golden-advice-body {
  font-size: 11pt;
  color: #78350f;
  line-height: 1.8;
}

/* Book recommendation */
.book-rec {
  display: flex;
  gap: 16px;
  background: var(--white);
  border: 1.5px solid var(--gray-200);
  border-radius: var(--radius-lg);
  padding: 18px;
  margin: 16px 0;
  align-items: flex-start;
}

.book-cover {
  width: 80px;
  height: 110px;
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
  border-radius: var(--radius-sm);
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-family: 'Inter', sans-serif;
  font-size: 7pt;
  text-align: center;
  padding: 8px;
  line-height: 1.4;
  font-weight: 600;
  direction: ltr;
  box-shadow: var(--shadow-md);
}

.book-info {
  flex: 1;
}

.book-title {
  font-size: 11pt;
  font-weight: 700;
  color: var(--primary-dark);
  margin-bottom: 4px;
  direction: ltr;
  text-align: left;
  font-family: 'Inter', sans-serif;
}

.book-desc {
  font-size: 10pt;
  color: var(--gray-600);
  line-height: 1.7;
}

/* Question mark decorative */
.question-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  background: var(--accent);
  color: white;
  border-radius: 50%;
  font-family: 'Inter', sans-serif;
  font-weight: 800;
  font-size: 14pt;
  margin-left: 6px;
  flex-shrink: 0;
}

/* Gear icon inline */
.gear-inline {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  color: var(--gray-500);
  font-size: 10pt;
}

.gear-inline svg {
  width: 14px;
  height: 14px;
}

/* Interview tag */
.interview-tag {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  background: var(--warning-bg);
  color: var(--warning);
  font-size: 9pt;
  font-weight: 700;
  padding: 3px 10px;
  border-radius: 20px;
  border: 1px solid rgba(234,88,12,0.2);
  margin-bottom: 8px;
}

.interview-tag svg {
  width: 12px;
  height: 12px;
}

/* Comparison table enhanced */
.compare-wrapper {
  margin: 20px 0;
}

.compare-label {
  font-size: 11pt;
  font-weight: 700;
  color: var(--gray-700);
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  gap: 6px;
}

/* ═══════════════════════════════════════════════════════
   PRINT STYLES
   ═══════════════════════════════════════════════════════ */
@media print {
  body { background: white; }
  .page {
    box-shadow: none;
    margin: 0;
    page-break-after: always;
  }
  .callout { break-inside: avoid; }
  .diagram-container { break-inside: avoid; }
  .table-wrapper { break-inside: avoid; }
}

/* ═══════════════════════════════════════════════════════
   ANIMATIONS (subtle, professional)
   ═══════════════════════════════════════════════════════ */
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}

.roadmap-step {
  animation: fadeInUp 0.5s ease both;
}
.roadmap-step:nth-child(1) { animation-delay: 0.05s; }
.roadmap-step:nth-child(3) { animation-delay: 0.15s; }
.roadmap-step:nth-child(5) { animation-delay: 0.25s; }
.roadmap-step:nth-child(7) { animation-delay: 0.35s; }
.roadmap-step:nth-child(9) { animation-delay: 0.45s; }
.roadmap-step:nth-child(11) { animation-delay: 0.55s; }
.roadmap-step:nth-child(13) { animation-delay: 0.65s; }
.roadmap-step:nth-child(15) { animation-delay: 0.75s; }

@keyframes pulseGlow {
  0%, 100% { box-shadow: 0 0 0 0 rgba(20,184,166,0.2); }
  50% { box-shadow: 0 0 0 8px rgba(20,184,166,0); }
}

.roadmap-step-icon {
  animation: pulseGlow 3s ease-in-out infinite;
}

.roadmap-step:nth-child(3) .roadmap-step-icon { animation-delay: 0.5s; }
.roadmap-step:nth-child(5) .roadmap-step-icon { animation-delay: 1s; }
.roadmap-step:nth-child(7) .roadmap-step-icon { animation-delay: 1.5s; }
.roadmap-step:nth-child(9) .roadmap-step-icon { animation-delay: 2s; }
.roadmap-step:nth-child(11) .roadmap-step-icon { animation-delay: 2.5s; }
.roadmap-step:nth-child(13) .roadmap-step-icon { animation-delay: 3s; }
.roadmap-step:nth-child(15) .roadmap-step-icon { animation-delay: 3.5s; }

@keyframes shimmer {
  0% { background-position: -200% center; }
  100% { background-position: 200% center; }
}

.chapter-divider {
  background: linear-gradient(90deg, var(--primary), var(--secondary), var(--accent), var(--secondary), var(--primary));
  background-size: 200% 100%;
  animation: shimmer 4s linear infinite;
}

@media (prefers-reduced-motion: reduce) {
  .roadmap-step, .roadmap-step-icon, .chapter-divider {
    animation: none !important;
  }
}
</style>
</head>
<body>

<!-- ═══════════════════════════════════════════════════════
     PAGE 1 — TABLE OF CONTENTS
     ═══════════════════════════════════════════════════════ -->
<div class="page">
  <div class="page-header">
    <span class="course-name">Embedded Linux &amp; Yocto</span>
    <span class="chapter-name">فهرس المحتويات</span>
  </div>
  <div class="page-footer">
    <span>الإصدار 1.0</span>
    <span class="page-num">1</span>
  </div>
  <div class="page-content">
    <div class="toc-container">
      <div class="toc-title">فهرس المحتويات</div>
      <div class="toc-subtitle">Embedded Linux &amp; Yocto — الدرس الثاني: Linux Architecture in Details</div>
      <div class="toc-divider"></div>

      <ul class="toc-list">
        <li class="toc-item main" onclick="scrollToSection('ch1')">
          <span><span class="toc-number">01</span> المعمارية البنية لنظام لينكس — Linux Architecture</span>
          <span class="toc-page">2</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s1-1')">
          <span>الطبقات الثلاث الأساسية</span>
          <span class="toc-page">2</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s1-2')">
          <span>لماذا تم فصل User Space عن Kernel Space؟</span>
          <span class="toc-page">2</span>
        </li>

        <li class="toc-item main" onclick="scrollToSection('ch2')">
          <span><span class="toc-number">02</span> مستويات الصلاحيات في العتاد — Hardware Exception Levels</span>
          <span class="toc-page">4</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s2-1')">
          <span>تعريفات سريعة</span>
          <span class="toc-page">4</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s2-2')">
          <span>كيف تعمل مستويات الصلاحيات في معمارية ARM</span>
          <span class="toc-page">4</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s2-3')">
          <span>مقارنة أنواع Hypervisor</span>
          <span class="toc-page">5</span>
        </li>

        <li class="toc-item main" onclick="scrollToSection('ch3')">
          <span><span class="toc-number">03</span> اللغز الأهم: كيف يتواصل User Space مع Kernel Space</span>
          <span class="toc-page">6</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s3-1')">
          <span>مثال توضيحي: المواطن والمدير</span>
          <span class="toc-page">6</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s3-2')">
          <span>كيف يعمل تحويل التطبيق إلى Process</span>
          <span class="toc-page">7</span>
        </li>

        <li class="toc-item main" onclick="scrollToSection('ch4')">
          <span><span class="toc-number">04</span> نداءات النظام — System Calls (Syscalls)</span>
          <span class="toc-page">8</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s4-1')">
          <span>تعريف System Call</span>
          <span class="toc-page">8</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s4-2')">
          <span>كيف تعمل System Calls فعلياً (خطوة بخطوة)</span>
          <span class="toc-page">8</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s4-3')">
          <span>العلاقة بين System Calls ومكتبة C</span>
          <span class="toc-page">9</span>
        </li>

        <li class="toc-item main" onclick="scrollToSection('ch5')">
          <span><span class="toc-number">05</span> واجهة التطبيقات الثنائية — ABI</span>
          <span class="toc-page">10</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s5-1')">
          <span>تعريف ABI</span>
          <span class="toc-page">10</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s5-2')">
          <span>لماذا يعتبر ABI ثابتاً ومقدساً؟</span>
          <span class="toc-page">10</span>
        </li>

        <li class="toc-item main" onclick="scrollToSection('ch6')">
          <span><span class="toc-number">06</span> ما هو الشل — Shell</span>
          <span class="toc-page">11</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s6-1')">
          <span>كيف يشتغل التطبيق؟</span>
          <span class="toc-page">11</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s6-2')">
          <span>ما هو دور Shell؟</span>
          <span class="toc-page">11</span>
        </li>

        <li class="toc-item main" onclick="scrollToSection('ch7')">
          <span><span class="toc-number">07</span> مدير الإقلاع الأول — Init Manager / Init Program</span>
          <span class="toc-page">12</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s7-1')">
          <span>تعريف init</span>
          <span class="toc-page">12</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s7-2')">
          <span>كيف يعمل؟</span>
          <span class="toc-page">12</span>
        </li>
        <li class="toc-item sub" onclick="scrollToSection('s7-3')">
          <span>مقارنة تطبيقات إدارة الإقلاع</span>
          <span class="toc-page">13</span>
        </li>

        <li class="toc-item main" onclick="scrollToSection('ch8')">
          <span><span class="toc-number">08</span> نصائح وأسئلة شائعة — Q&amp;A</span>
          <span class="toc-page">14</span>
        </li>

        <li class="toc-item main" onclick="scrollToSection('qr')">
          <span><span class="toc-number">■</span> مراجعة سريعة — Quick Review</span>
          <span class="toc-page">15</span>
        </li>
      </ul>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════════════════════
     PAGE 2 — CHAPTER 1: LINUX ARCHITECTURE
     ═══════════════════════════════════════════════════════ -->
<div class="page" id="ch1">
  <div class="page-header">
    <span class="course-name">Embedded Linux &amp; Yocto</span>
    <span class="chapter-name">الدرس الثاني: Linux Architecture in Details</span>
  </div>
  <div class="page-footer">
    <span>الإصدار 1.0</span>
    <span class="page-num">2</span>
  </div>
  <div class="page-content">
    <!-- Chapter Opening -->
    <div class="chapter-opening">
      <div class="trainer-badge">
        <span class="trainer-icon">
          <svg viewBox="0 0 24 24" fill="white"><path d="M12 12c2.7 0 4.8-2.1 4.8-4.8S14.7 2.4 12 2.4 7.2 4.5 7.2 7.2 9.3 12 12 12zm0 2.4c-3.2 0-9.6 1.6-9.6 4.8v2.4h19.2v-2.4c0-3.2-6.4-4.8-9.6-4.8z"/></svg>
        </span>
        المدرب: سالم بالحاج طلال — Embedded Linux Architect
      </div>
      <div class="chapter-number">CHAPTER 01</div>
      <div class="chapter-icon">
        <svg viewBox="0 0 24 24" fill="white"><path d="M4 6h16v2H4zm0 5h16v2H4zm0 5h16v2H4z"/><path d="M20 2H4c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 18H4V4h16v16z" opacity="0.3"/></svg>
      </div>
      <div class="chapter-title">المعمارية البنية لنظام لينكس</div>
      <div class="chapter-subtitle">Linux Architecture — User Space, Kernel Space, Hardware</div>
      <div class="chapter-divider"></div>
      <div class="chapter-intro">
        موضوع الدرس: البنية المعمارية لنظام Linux، مستويات الصلاحيات في العتاد (Exception Levels)، نداءات النظام (System Calls)، ومعيار ABI.
      </div>
    </div>

    <!-- Animated Chapter Overview -->
    <div class="overview-container">
      <div class="overview-label">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7"/></svg>
        خريطة المسار التعليمي — Learning Roadmap
      </div>
      <div class="roadmap">
        <div class="roadmap-step step-blue">
          <div class="roadmap-step-icon">
            <span class="roadmap-step-num">1</span>
            <svg viewBox="0 0 24 24" fill="white"><path d="M4 6h16v2H4zm0 5h16v2H4zm0 5h16v2H4z"/></svg>
          </div>
          <div class="roadmap-step-title">Linux Architecture</div>
          <div class="roadmap-step-desc">User Space / Kernel / Hardware</div>
        </div>
        <div class="roadmap-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5m7-7l-7 7 7 7"/></svg></div>
        <div class="roadmap-step step-teal">
          <div class="roadmap-step-icon">
            <span class="roadmap-step-num">2</span>
            <svg viewBox="0 0 24 24" fill="white"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/></svg>
          </div>
          <div class="roadmap-step-title">Exception Levels</div>
          <div class="roadmap-step-desc">EL0 → EL3 في ARM</div>
        </div>
        <div class="roadmap-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5m7-7l-7 7 7 7"/></svg></div>
        <div class="roadmap-step step-orange">
          <div class="roadmap-step-icon">
            <span class="roadmap-step-num">3</span>
            <svg viewBox="0 0 24 24" fill="white"><path d="M8 5v14l11-7z"/></svg>
          </div>
          <div class="roadmap-step-title">التواصل بين المساحتين</div>
          <div class="roadmap-step-desc">User ↔ Kernel</div>
        </div>
        <div class="roadmap-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5m7-7l-7 7 7 7"/></svg></div>
        <div class="roadmap-step step-green">
          <div class="roadmap-step-icon">
            <span class="roadmap-step-num">4</span>
            <svg viewBox="0 0 24 24" fill="white"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>
          </div>
          <div class="roadmap-step-title">System Calls</div>
          <div class="roadmap-step-desc">الآلية الرسمية للطلب</div>
        </div>
        <div class="roadmap-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5m7-7l-7 7 7 7"/></svg></div>
        <div class="roadmap-step step-purple">
          <div class="roadmap-step-icon">
            <span class="roadmap-step-num">5</span>
            <svg viewBox="0 0 24 24" fill="white"><path d="M9.4 16.6L4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0l4.6-4.6-4.6-4.6L16 6l6 6-6 6-1.4-1.4z"/></svg>
          </div>
          <div class="roadmap-step-title">ABI</div>
          <div class="roadmap-step-desc">القانون الثابت المقدس</div>
        </div>
        <div class="roadmap-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5m7-7l-7 7 7 7"/></svg></div>
        <div class="roadmap-step step-red">
          <div class="roadmap-step-icon">
            <span class="roadmap-step-num">6</span>
            <svg viewBox="0 0 24 24" fill="white"><path d="M11 7h2v2h-2zm0 4h2v6h-2zm1-9C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/></svg>
          </div>
          <div class="roadmap-step-title">Shell &amp; Init</div>
          <div class="roadmap-step-desc">بداية تشغيل النظام</div>
        </div>
      </div>
    </div>

    <!-- Section 1 -->
    <div class="section" id="s1-1">
      <div class="section-header">
        <div class="section-number">1.1</div>
        <div class="section-title">المعمارية البنية لنظام Linux</div>
      </div>

      <p>هذا الدرس يعتمد على المفاھيم التي تم شرحھا في الدرس الأول (POSIX, GNU, Glibc, Kernel) وينتقل إلى فهم أعمق لكیفية تواصل ھذه المكونات مع بعضھا ومع العتاد.</p>

      <p>ينقسم نظام لینكس أساسیاً إلى ثلاث طبقات رئیسیة:</p>

      <!-- Architecture Diagram -->
      <div class="diagram-container">
        <div class="diagram-title">معمارية نظام Linux — Linux Architecture</div>
        <div class="diagram">
          <div class="diagram-layer layer-user en">User Space — التطبيقات، سطر الأوامر، المتصفح، إلخ</div>
          <div class="diagram-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 5v14m-7-7l7 7 7-7"/></svg></div>
          <div class="diagram-layer layer-syscall en">System Calls — الواجهة الرسمية بين المساحتين</div>
          <div class="diagram-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 5v14m-7-7l7 7 7-7"/></svg></div>
          <div class="diagram-layer layer-kernel en">Kernel Space — النواة (تعمل بصلاحيات مطلقة)</div>
          <div class="diagram-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 5v14m-7-7l7 7 7-7"/></svg></div>
          <div class="diagram-layer layer-hw en">Hardware — CPU، RAM، وحدات التخزين، والمنافذ</div>
        </div>
      </div>

      <ol>
        <li><strong>User Space (مساحة المستخدم):</strong> المكان الذي تعمل فیه التطبیقات العادیة للمستخدم (مثل المتصفح، سطر الأوامر، إلخ).</li>
        <li><strong>Kernel Space (مساحة النواة):</strong> المكان الذي تعمل فیه النواة (Kernel) وتتمتع فیھ بصلاحیات مطلقة.</li>
        <li><strong>Hardware (العتاد):</strong> المكونات الفیزیائیة مثل المعالج (CPU)، الذاكرة (RAM)، وحدات التخزین، والمنافذ.</li>
      </ol>
    </div>

    <!-- Subsection: Why Separation -->
    <div class="subsection" id="s1-2">
      <div class="subsection-title">لماذا تم فصل User Space عن Kernel Space؟</div>

      <ul class="primary-bullets">
        <li><strong>دواعي أمنية (Security Reasons):</strong> لو امتلكت المستخدم تطبیقات صلاحية الوصول المباشر للعتاد (أو أي تطبیق)، فيمكن لفیروس/مخترق بالعبث بالذاكرة أو بالتحكم بالعتاد بشكل یضر بالنظام بالكامل.</li>
        <li><strong>ترك التنظیم:</strong> لإدارة الموارد وإدارة العملیات (Process Management / Scheduler) مھمة ترك للنواة فقط لضمان عمل النظام باستقرار.</li>
      </ul>

      <div class="callout callout-green">
        <div class="callout-header">
          <span class="callout-icon">✅</span>
          Key Takeaway — ما يجب أن تتذكر؟
        </div>
        <div class="callout-body">
          <p>دائماً تتكون البنیة الأساسیة للینكس من <strong>3 أجزاء</strong>: User Space, Kernel Space, Hardware</p>
        </div>
      </div>

      <div class="callout callout-red">
        <div class="callout-header">
          <span class="callout-icon">⚠️</span>
          أخطاء شائعة
        </div>
        <div class="callout-body">
          <p>الاعتقاد بأن التطبیقات التي نكتبھا تتحكم مباشرة في الـ Hardware — ھذا مستحیل ویمنعھ النظام من الجذور.</p>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════════════════════
     PAGE 3 — CHAPTER 2: EXCEPTION LEVELS
     ═══════════════════════════════════════════════════════ -->
<div class="page" id="ch2">
  <div class="page-header">
    <span class="course-name">Embedded Linux &amp; Yocto</span>
    <span class="chapter-name">الدرس الثاني: Linux Architecture in Details</span>
  </div>
  <div class="page-footer">
    <span>الإصدار 1.0</span>
    <span class="page-num">3</span>
  </div>
  <div class="page-content">
    <div class="section" id="s2-1">
      <div class="section-header">
        <div class="section-number">2</div>
        <div class="section-title">مستويات الصلاحيات في العتاد — Hardware Exception Levels</div>
      </div>

      <p>الفصل بین مساحة المستخدم ومساحة النواة ليس مجرد "كود برمجي" بل هو مدعوم من قبل نفس العتاد (Hardware) ويتم تنظیم ھذا الفصل عبر ما یسمى بـ <span class="en-term">Exception Levels (EL)</span> (مع معالجات ARM مثل Cortex-A).</p>

      <div class="callout callout-gray">
        <div class="callout-header">
          <span class="callout-icon">📌</span>
          تعريفات سريعة
        </div>
        <div class="callout-body">
          <p><strong><span class="en-term">ISA (Instruction Set Architecture)</span>:</strong> "القانون" أو الھندسي التصمیم الذي یحدد شكل الأوامر (<span class="en-term">Instructions</span>) والسجلات (<span class="en-term">Registers</span>) الخاصة بالمعالج (مثل ARM v7, ARM v8).</p>
          <p><strong><span class="en-term">Hypervisor</span>:</strong> نظام أو برنامج یمتلك صلاحیات أعلى من الـ Kernel، وظیفتھ تشغیل أنظمة تشغیل عدة (<span class="en-term">Operating Systems</span>) في نفس الوقت على نفس العتاد.</p>
        </div>
      </div>
    </div>

    <!-- Exception Levels Table & Diagram -->
    <div class="subsection" id="s2-2">
      <div class="subsection-title">كيف تعمل مستويات الصلاحيات في معمارية ARM</div>

      <p>تُقسم الصلاحيات إلى <strong>4 مستویات</strong> (من الأقل للأعلى):</p>

      <!-- Exception Levels Diagram -->
      <div class="diagram-container">
        <div class="diagram-title">مستويات الصلاحيات في ARM — Exception Levels</div>
        <div class="el-diagram">
          <div class="el-level el-3">
            <div class="el-badge">EL3</div>
            <div class="el-info">
              <div class="el-name">Secure Monitor</div>
              <div class="el-desc">أعلى مستوى صلاحیات — یتحكم في الجوانب الأمنیة المتقدمة (TrustZone — سیتم شرحھ في دروس متقدمة).</div>
            </div>
          </div>
          <div class="el-level el-2">
            <div class="el-badge">EL2</div>
            <div class="el-info">
              <div class="el-name">Hypervisor</div>
              <div class="el-desc">یملك صلاحیات أعلى من النواة — یتحكم في تقسیم العتاد بین أنظمة تشغیل عدة تعمل بالتوازي.</div>
            </div>
          </div>
          <div class="el-level el-1">
            <div class="el-badge">EL1</div>
            <div class="el-info">
              <div class="el-name">Kernel Space</div>
              <div class="el-desc">النواة تعمل ھنا (OS Kernel) — تملك صلاحية التحكم بالعتاد والـ Hardware Peripherals.</div>
            </div>
          </div>
          <div class="el-level el-0">
            <div class="el-badge">EL0</div>
            <div class="el-info">
              <div class="el-name">User Space</div>
              <div class="el-desc">أقل مستوى صلاحیات — تعمل ھنا تطبیقات المستخدم (Applications) — لا تملك أي قدرة على الوصول المباشر للعتاد.</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Exception Levels Table -->
      <div class="table-wrapper">
        <table>
          <thead>
            <tr>
              <th>المستوى</th>
              <th>الاسم التقني</th>
              <th>الوظیفة</th>
              <th>مكان العمل</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td class="num-cell">EL0</td>
              <td class="en-cell">User Space</td>
              <td>أقل مستوى صلاحیات. تعمل ھنا تطبیقات المستخدم (Applications). لا تملك أي قدرة على الوصول المباشر للعتاد.</td>
              <td>تطبیقات المستخدم</td>
            </tr>
            <tr>
              <td class="num-cell">EL1</td>
              <td class="en-cell">Kernel Space</td>
              <td>النواة تعمل ھنا (OS Kernel). تملك صلاحية التحكم بالعتاد والـ Hardware Peripherals.</td>
              <td>النواة</td>
            </tr>
            <tr>
              <td class="num-cell">EL2</td>
              <td class="en-cell">Hypervisor</td>
              <td>یملك صلاحیات أعلى من النواة — یتحكم في تقسیم العتاد بین أنظمة تشغیل عدة تعمل بالتوازي.</td>
              <td>تشغیل أنظمة عدة</td>
            </tr>
            <tr>
              <td class="num-cell">EL3</td>
              <td class="en-cell">Secure Monitor</td>
              <td>أعلى مستوى صلاحیات — یتحكم في الجوانب الأمنیة المتقدمة (TrustZone — سیتم شرحھ في دروس متقدمة).</td>
              <td>الأمن المتقدم</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="flash-review">
        <div class="flash-title">⚡ مراجعة سريعة</div>
        <ul>
          <li><span class="en-term">EL0</span>: User</li>
          <li><span class="en-term">EL1</span>: Kernel</li>
          <li><span class="en-term">EL2</span>: Hypervisor</li>
          <li><span class="en-term">EL3</span>: Secure Monitor</li>
        </ul>
      </div>

      <div class="callout callout-green">
        <div class="callout-header">
          <span class="callout-icon">✅</span>
          Key Takeaway — ما يجب أن تتذكر؟
        </div>
        <div class="callout-body">
          <p>إذا جاء الأمر من <span class="en-term">EL0</span> فإن المعالج (<span class="en-term">CPU</span>) نفسھ یعرف مصدر الأمر (<span class="en-term">Instruction</span>) وحاول الوصول إلى عنوان ذاكرة مخصص لـ <span class="en-term">EL1</span>، فإن المعالج سیرفض التنفیذ فوراً للحمایة.</p>
        </div>
      </div>
    </div>

    <!-- Hypervisor Comparison -->
    <div class="subsection" id="s2-3">
      <div class="subsection-title">مقارنة أنواع Hypervisor</div>

      <div class="compare-wrapper">
        <div class="compare-label">مقارنة وجھ لوجھ</div>
        <div class="table-wrapper">
          <table class="comparison">
            <thead>
              <tr>
                <th>وجھ المقارنة</th>
                <th>Type 1 Hypervisor (Bare-metal)</th>
                <th>Type 2 Hypervisor (Hosted)</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>كیف یعمل؟</td>
                <td>یعمل مباشرة فوق العتاد (Hardware).</td>
                <td>یعمل كتطبیق فوق نظام تشغیل موجود مسبقاً.</td>
              </tr>
              <tr>
                <td>أین یُستخدم؟</td>
                <td>الخوادم (Servers)، أنظمة السیارات (Automotive).</td>
                <td>الأجھزة الشخصیة، الحواسیب العادیة.</td>
              </tr>
              <tr>
                <td>أمثلة</td>
                <td class="en-cell">Xen، QNX (أحیاناً یُستخدم كـ Type 1)</td>
                <td class="en-cell">VirtualBox, VMware, QEMU</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════════════════════
     PAGE 4 — CHAPTER 3: USER SPACE ↔ KERNEL SPACE
     ═══════════════════════════════════════════════════════ -->
<div class="page" id="ch3">
  <div class="page-header">
    <span class="course-name">Embedded Linux &amp; Yocto</span>
    <span class="chapter-name">الدرس الثاني: Linux Architecture in Details</span>
  </div>
  <div class="page-footer">
    <span>الإصدار 1.0</span>
    <span class="page-num">4</span>
  </div>
  <div class="page-content">
    <div class="section" id="s3-1">
      <div class="section-header">
        <div class="section-number">3</div>
        <div class="section-title">
          اللغز الأهم: كيف يتواصل User Space مع Kernel Space
          <span class="question-badge">؟</span>
        </div>
      </div>

      <div class="interview-tag">
        <svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 2H4c-1.1 0-2 .9-2 2v18l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H5.17L4 17.17V4h16v12z"/></svg>
        سؤال شھیر في المقابلات الوظیفية (Interviews)
      </div>

      <p>هذا السؤال هو "فخ" شھیر في المقابلات الوظیفية: إذا كان التطبیق في <span class="en-term">User Space</span> ولا یملك أي صلاحیات للوصول إلى <span class="en-term">Kernel Space</span> أو العتاد، فكیف یستطيع مثلاً قراءة ملف من الھارد دیسك؟!</p>

      <!-- Citizen/Manager Example -->
      <div class="callout callout-dark">
        <div class="callout-header">
          <span class="callout-icon">🚀</span>
          مثال توضیحي — المواطن والمدیر (مثال مطابق للواقع التقني)
        </div>
        <div class="callout-body">
          <p>المدرب استخدم هذا المثال لتبسیط اللغز المعقد:</p>
          <ul style="list-style:none; padding:0;">
            <li style="padding-right:0; margin-bottom:8px;"><strong>المواطن العادي:</strong> هو التطبیق (<span class="en-term">Application / Binary File</span>).</li>
            <li style="padding-right:0; margin-bottom:8px;"><strong>مكتب المدیر (وبه المحیط والمجال):</strong> هو الـ <span class="en-term">Kernel Space</span>.</li>
            <li style="padding-right:0; margin-bottom:8px;"><strong>المدیر:</strong> هو الـ <span class="en-term">Kernel / Scheduler</span>.</li>
            <li style="padding-right:0; margin-bottom:8px;"><strong>الموظف داخل مكتب المدیر:</strong> هو العملیة (<span class="en-term">Process</span>).</li>
          </ul>
          <p><strong>الحل؟</strong> المواطن (<span class="en-term">Application</span>) لا یمكنه الدخول لمكتب المدیر. لكنه یتحول إلى "موظف" (<span class="en-term">Process</span>) یمتلك ھویة جدیدة تسمح لھ بالعمل داخل حدود النظام وتقدیم الطلبات للمدیر.</p>
        </div>
      </div>
    </div>

    <!-- Process Creation Flow -->
    <div class="subsection" id="s3-2">
      <div class="subsection-title">كيف يعمل تحويل التطبيق إلى Process</div>

      <!-- Process Creation Diagram -->
      <div class="diagram-container">
        <div class="diagram-title">تدفق إنشاء العملية — Process Creation Flow</div>
        <div class="process-flow">
          <div class="pf-box pf-storage en">Storage — الكود المصدري للتطبيق (Binary File) موجود في وحدة التخزین</div>
          <div class="pf-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14m-7-7l7 7 7-7"/></svg></div>
          <div class="pf-box pf-userspace">عندما تطلب تشغیل التطبیق، لا یتم نقل كوده بالكامل إلى Kernel Space لكي لا یكتسب صلاحیات مطلقة.</div>
          <div class="pf-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14m-7-7l7 7 7-7"/></svg></div>
          <div class="pf-box pf-kernel">بدلاً من ذلك، تقوم النواة بنسخه إلى الذاكرة في User Space وتنشئ لھ ملف تعریف / ھویة داخل Kernel Space.</div>
          <div class="pf-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14m-7-7l7 7 7-7"/></svg></div>
          <div class="pf-box pf-userspace en">Process — یحتوي على بیانات التطبیق، مساحته في الذاكرة، ومعرّف خاص بھ (ID).</div>
          <div class="pf-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14m-7-7l7 7 7-7"/></svg></div>
          <div class="pf-box pf-scheduler en">Scheduler — یقوم بإدارة الـ Processes ھذه وتحدیث من یعمل أولاً.</div>
        </div>
      </div>

      <ol>
        <li>الكود المصدري للتطبيق (<span class="en-term">Binary File</span>) موجود في وحدة التخزین (<span class="en-term">Storage</span>).</li>
        <li>عندما تطلب تشغیل التطبیق، لا یتم نقل كوده بالكامل إلى <span class="en-term">Kernel Space</span> لكي لا یكتسب صلاحیات مطلقة.</li>
        <li>بدلاً من ذلك، تقوم النواة بنسخه إلى الذاكرة في <span class="en-term">User Space</span> وتنشئ لھ ملف تعریف / ھویة داخل <span class="en-term">Kernel Space</span> (یسمى <span class="en-term">Process</span> أو <span class="en-term">Task</span>).</li>
        <li>الـ <span class="en-term">Process</span> یحتوي على بیانات التطبیق، مساحته في الذاكرة، ومعرّف خاص بھ (<span class="en-term">ID</span>).</li>
        <li>یقوم الـ <span class="en-term">Scheduler</span> بإدارة الـ <span class="en-term">Processes</span> ھذه وتحدیث من یعمل أولاً.</li>
      </ol>

      <div class="callout callout-green">
        <div class="callout-header">
          <span class="callout-icon">✅</span>
          Key Takeaway — ما يجب أن تتذكر؟
        </div>
        <div class="callout-body">
          <p>لیس لأي تطبیق أن یعمل مباشرة — يجب أن تقوم النواة (<span class="en-term">Kernel</span>) بتحویلھ أولاً إلى عملیة (<span class="en-term">Process</span>) قابلة للجدولة (<span class="en-term">Scheduling</span>).</p>
        </div>
      </div>

      <div class="callout callout-red">
        <div class="callout-header">
          <span class="callout-icon">⚠️</span>
          أخطاء شائعة
        </div>
        <div class="callout-body">
          <p>الاعتقاد بأن التطبیق عندما یعمل یتم نقلھ إلى الكیرنل — الصحیح أن الكیرنل ینشئ لھ ملف "ھویة/ملف" فقط (<span class="en-term">Process</span>) ویبقى التطبیق كود معزولاً في <span class="en-term">User Space</span> لیتتبعھ.</p>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════════════════════
     PAGE 5 — CHAPTER 4: SYSTEM CALLS
     ═══════════════════════════════════════════════════════ -->
<div class="page" id="ch4">
  <div class="page-header">
    <span class="course-name">Embedded Linux &amp; Yocto</span>
    <span class="chapter-name">الدرس الثاني: Linux Architecture in Details</span>
  </div>
  <div class="page-footer">
    <span>الإصدار 1.0</span>
    <span class="page-num">5</span>
  </div>
  <div class="page-content">
    <div class="section" id="s4-1">
      <div class="section-header">
        <div class="section-number">4</div>
        <div class="section-title">نداءات النظام — System Calls (Syscalls)</div>
      </div>

      <p>حتى بعد أن یصبح التطبیق <span class="en-term">Process</span> ویعمل، فھو لا یزال لا یمتلك وصولاً للعتاد — يجب علیھ أن یطلب ذلك من الكیرنل عبر آلیة مقدسة تسمى <span class="en-term">System Call</span>.</p>

      <div class="callout callout-gray">
        <div class="callout-header">
          <span class="callout-icon">📌</span>
          تعريف
        </div>
        <div class="callout-body">
          <p><strong><span class="en-term">System Call</span>:</strong> هو طلب رسمي واحد یقوم بھ التطبیق في <span class="en-term">User Space</span> لیطلب من النواة (<span class="en-term">Kernel Space</span>) أداء مھمة تحتاج لصلاحیات (مثل فتح ملف، القراءة، الكتابة).</p>
        </div>
      </div>
    </div>

    <!-- How Syscalls Work -->
    <div class="subsection" id="s4-2">
      <div class="subsection-title">كيف تعمل System Calls فعلياً (خطوة بخطوة)</div>

      <p>التطبیق لا یمكنه التحدث مباشرة للكیرنل — وسیلتھ الوحیدة هی بما یسمى بالمقاطعات (<span class="en-term">Interrupts</span> / الاستثناءات) لفت انتباه المعالج (<span class="en-term">CPU</span>).</p>

      <!-- Syscall Flow Diagram -->
      <div class="diagram-container">
        <div class="diagram-title">تدفق تنفيذ System Call — Syscall Execution Flow</div>
        <div class="syscall-flow">
          <div class="sf-step">
            <div class="sf-num">1</div>
            <div class="sf-content"><strong>تجھیز الطلب:</strong> كل نظام نداء لھ رقم تعریفي (<span class="en-term">ID</span>) ومعاملات (<span class="en-term">Arguments</span>). مثلاً: نداء الكتابة <span class="en-term">write</span> لھ رقم <code>1</code> في بعض المعماریات.</div>
          </div>
          <div class="sf-arrow-down"></div>
          <div class="sf-step">
            <div class="sf-num">2</div>
            <div class="sf-content"><strong>استخدام السجلات:</strong> یقوم التطبیق بوضع الـ <span class="en-term">ID</span> الخاص بالنداء في معین سجل في <span class="en-term">CPU</span> (<span class="en-term">CPU Registers</span>) ویضع المعاملات (<span class="en-term">Arguments</span>) في سجلات أخرى. (مثلاً: سجل <code>RAX</code> في معماریة x86_64، أو <code>X8</code> في معماریة ARM).</div>
          </div>
          <div class="sf-arrow-down"></div>
          <div class="sf-step">
            <div class="sf-num">3</div>
            <div class="sf-content"><strong>إطلاق المقاطعة:</strong> یقوم التطبیق بتنفیذ أمر <span class="en-term">Assembly</span> خاص (مثل <code>syscall</code> في x86 أو <code>svc</code> في ARM) — <strong>Trigger Interrupt</strong>.</div>
          </div>
          <div class="sf-arrow-down"></div>
          <div class="sf-step">
            <div class="sf-num">4</div>
            <div class="sf-content"><strong>توقف المعالج وتنبیھ النواة:</strong> ھذا الأمر یوقف عمل الـ <span class="en-term">CPU</span> العادي ویطلق <span class="en-term">Interrupt</span> ویخبر الـ <span class="en-term">Kernel</span> بأن ھناك انتباھاً مطلوباً.</div>
          </div>
          <div class="sf-arrow-down"></div>
          <div class="sf-step">
            <div class="sf-num">5</div>
            <div class="sf-content"><strong>تنفیذ الطلب:</strong> الـ <span class="en-term">Kernel</span> یتفحص السجلات (<span class="en-term">Registers</span>) یقرأ الـ <span class="en-term">ID</span> (یتعرف مثلاً أنھ أمر <span class="en-term">write</span>) ینفذ المھمة ثم یعید النتیجة للتطبیق.</div>
          </div>
        </div>
      </div>

      <div class="callout callout-blue">
        <div class="callout-header">
          <span class="callout-icon">📘</span>
          Concept — مثال على التعليمات
        </div>
        <div class="callout-body">
          <div class="code-block">
            <div class="code-header">
              <div class="code-dots"><span></span><span></span><span></span></div>
              <div class="code-lang">Assembly — ARM</div>
            </div>
            <div class="code-body"><span class="cmt">; تحضير رقم نداء النظام في السجل X8</span>
<span class="reg">MOV</span> <span class="reg">X8</span>, <span class="num">#64</span>     <span class="cmt">; رقم syscall للـ write في ARM</span>

<span class="cmt">; تحضير المعاملات في السجلات الأخرى</span>
<span class="reg">MOV</span> <span class="reg">X0</span>, <span class="num">#1</span>       <span class="cmt">; file descriptor (stdout)</span>
<span class="reg">ADR</span> <span class="reg">X1</span>, msg       <span class="cmt">; عنوان النص</span>
<span class="reg">MOV</span> <span class="reg">X2</span>, <span class="num">#13</span>      <span class="cmt">; طول النص</span>

<span class="cmt">; إطلاق المقاطعة — Trigger Interrupt</span>
<span class="kw">SVC</span> <span class="num">#0</span>            <span class="cmt">; استدعاء النظام (Supervisor Call)</span></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Relationship with C Library -->
    <div class="subsection" id="s4-3">
      <div class="subsection-title">العلاقة بين System Calls ومكتبة C</div>

      <ul class="primary-bullets">
        <li>دوال لغة C الموجودة في مكتبة <span class="en-term">glibc</span> مثل <code>printf</code> أو <code>scanf</code> هی في الحقیقة واجھة مجردة (<span class="en-term">Abstraction</span>) مبسطة.</li>
        <li>دالة <code>printf</code> من الداخل تقوم بتجھیز السجلات (<span class="en-term">Registers</span>) وتستدعي نداء النظام الحقیقي وھو <span class="en-term">write</span>.</li>
        <li>یمكنك القیام بـ <span class="en-term">System Call</span> مباشرة بكتابة أوامر <span class="en-term">Assembly</span> والاستغناء تماماً عن <span class="en-term">glibc</span> (ولكن ھذا صعب وغیر عملي برمجیاً).</li>
      </ul>

      <div class="callout callout-green">
        <div class="callout-header">
          <span class="callout-icon">✅</span>
          Key Takeaway — ما يجب أن تتذكر؟
        </div>
        <div class="callout-body">
          <p>التطبیق لا یصل للعتاد، بل یضع أوامره في الـ <span class="en-term">Registers</span> ثم یقوم بعمل <span class="en-term">Interrupt</span> لیجبر الـ <span class="en-term">Kernel</span> على الاستجابة لطلبھ.</p>
        </div>
      </div>

      <div class="flash-review">
        <div class="flash-title">⚡ مراجعة سريعة</div>
        <ul>
          <li><code>printf</code> <span style="color:#fbbf24;">⬅</span> System Interface (C Library)</li>
          <li><span class="en-term">write</span> <span style="color:#fbbf24;">⬅</span> System Call</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════════════════════
     PAGE 6 — CHAPTER 5: ABI
     ═══════════════════════════════════════════════════════ -->
<div class="page" id="ch5">
  <div class="page-header">
    <span class="course-name">Embedded Linux &amp; Yocto</span>
    <span class="chapter-name">الدرس الثاني: Linux Architecture in Details</span>
  </div>
  <div class="page-footer">
    <span>الإصدار 1.0</span>
    <span class="page-num">6</span>
  </div>
  <div class="page-content">
    <div class="section" id="s5-1">
      <div class="section-header">
        <div class="section-number">5</div>
        <div class="section-title">واجهة التطبيقات الثنائية — ABI (Application Binary Interface)</div>
      </div>

      <p>كیف یعرف التطبیق أن رقم نداء <span class="en-term">write</span> ھو <code>1</code> وما یضمن أن الكیرنل سیعتبر الرقم <code>1</code> ھو <span class="en-term">write</span> ولیس <span class="en-term">read</span>؟</p>

      <div class="callout callout-gray">
        <div class="callout-header">
          <span class="callout-icon">📌</span>
          تعريف
        </div>
        <div class="callout-body">
          <p><strong><span class="en-term">ABI (Application Binary Interface)</span>:</strong> ھو قانون أو معیار مقدس وثابت داخل نظام لینكس — عبارة عن جدول یحدد بدقة متناھیة:</p>
          <ol>
            <li>أرقام (<span class="en-term">IDs</span>) الخاصة بكل <span class="en-term">System Call</span>.</li>
            <li>طریقة استدعاء الدوال (<span class="en-term">Calling Convention</span>): أسماء الـ <span class="en-term">Registers</span> التي یجب أن توضع فیھا الـ <span class="en-term">IDs</span> والمعاملات.</li>
          </ol>
        </div>
      </div>
    </div>

    <!-- Why ABI is sacred -->
    <div class="subsection" id="s5-2">
      <div class="subsection-title">لماذا يعتبر ABI ثابتاً ومقدساً؟</div>

      <p>لو قرر مطورو نواة لینكس (Linus Torvalds وفریقھ) تغییر رقم الـ <span class="en-term">write</span> في جدول الـ <span class="en-term">ABI</span> من <code>1</code> إلى <code>50</code> مثلاً...</p>

      <ol>
        <li>البرامج القدیمة الموجودة في العالم التي تم عمل لها <span class="en-term">Compile</span> سابقاً على وضع الرقم <code>1</code> ستتوقف عن العمل فوراً.</li>
        <li>یعني ذلك تغییر الـ <span class="en-term">ABI</span> بالكامل — ولذلك الـ <span class="en-term">ABI</span> في لینكس لا یتغیر أبداً (<span class="en-term">Stable</span>).</li>
      </ol>

      <div class="callout callout-red">
        <div class="callout-header">
          <span class="callout-icon">⚠️</span>
          Important — نقطة بالغة الأهمية
        </div>
        <div class="callout-body">
          <p>تغییر الـ <span class="en-term">ABI</span> یعنی انھیار النظام بالكامل — جمیع البرامج الحالیة ستتوقف عن العمل فوراً.</p>
        </div>
      </div>

      <div class="callout callout-green">
        <div class="callout-header">
          <span class="callout-icon">✅</span>
          Key Takeaway — ما يجب أن تتذكر؟
        </div>
        <div class="callout-body">
          <p><code>printf</code> مثل واجھة الكود المكتوب (الـ <span class="en-term">API</span>). الـ <span class="en-term">ABI</span> ھو واجھة النظام للتعامل مع التطبیقات بعد أن تتحول إلى <span class="en-term">Binary</span> (كیفیة ترتیب الـ <span class="en-term">Registers</span> وأرقام الـ <span class="en-term">Syscalls</span>).</p>
        </div>
      </div>

      <!-- API vs ABI comparison -->
      <div class="compare-wrapper">
        <div class="compare-label">مقارنة: API مقابل ABI</div>
        <div class="table-wrapper">
          <table class="comparison">
            <thead>
              <tr>
                <th>وجھ المقارنة</th>
                <th><span class="en-term">API</span></th>
                <th><span class="en-term">ABI</span></th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>المستوى</td>
                <td>واجھة الكود المكتوب (المصدر)</td>
                <td>واجھة النظام للتعامل مع التطبیقات بعد التحویل إلى Binary</td>
              </tr>
              <tr>
                <td>مثال</td>
                <td class="en-cell"><code>printf()</code></td>
                <td class="en-cell">أرقام الـ Registers وأرقام الـ Syscalls</td>
              </tr>
              <tr>
                <td>المستخدم</td>
                <td>المبرمج یكتب الكود</td>
                <td>النظام یتعامل مع التطبیق المُcompiled</td>
              </tr>
              <tr>
                <td>الثبات</td>
                <td>قد یتغیر بین الإصدارات</td>
                <td>ثابت ومقدس — لا یتغیر أبداً</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════════════════════
     PAGE 7 — CHAPTER 6: SHELL
     ═══════════════════════════════════════════════════════ -->
<div class="page" id="ch6">
  <div class="page-header">
    <span class="course-name">Embedded Linux &amp; Yocto</span>
    <span class="chapter-name">الدرس الثاني: Linux Architecture in Details</span>
  </div>
  <div class="page-footer">
    <span>الإصدار 1.0</span>
    <span class="page-num">7</span>
  </div>
  <div class="page-content">
    <div class="section" id="s6-1">
      <div class="section-header">
        <div class="section-number">6</div>
        <div class="section-title">ما هو الشل — Shell</div>
      </div>

      <p>إذا كان تشغیل التطبیقات یحتاج إلى الدخول إلى الكیرنل لإنشاء <span class="en-term">Process</span>، فكیف نبدأ بتشغیل أول تطبیق؟</p>

      <div class="subsection-title">كيف يشتغل التطبيق؟</div>

      <p>لتشغیل تطبیق معین، یجب أن یقوم آخر تطبیق یشتغل فعلاً بعمل <span class="en-term">System Call</span> (مثل <code>execve</code>) فیھ یطلب من الكیرنل تشغیل التطبیق الجدید.</p>

      <div class="subsection-title" id="s6-2">ما هو دور Shell؟</div>

      <ol>
        <li>الشل ھو مجرد تطبیق (<span class="en-term">Application/Process</span>) یعیش في <span class="en-term">User Space</span> مثل أي تطبیق آخر.</li>
        <li>وظیفتھ الأساسیة: ھو "الواسطة" التي نستخدمھا لطلب تشغیل التطبیقات الأخرى من الكیرنل.</li>
        <li>كمترجم: یمتلك لغة برمجة خاصة بھ تحتوي على شروط (if, while) وحلقات تكرار (for).</li>
        <li>أمثلة على الشل: <span class="en-term">bash, sh, zsh</span> (جمیعھا <span class="en-term">Implementations</span> مختلفة لنفس مفھوم الـ <span class="en-term">POSIX Shell</span>).</li>
      </ol>

      <div class="callout callout-purple">
        <div class="callout-header">
          <span class="callout-icon">🧠</span>
          Deep Understanding — فهم أعمق
        </div>
        <div class="callout-body">
          <p>الشل ليس جزءاً من النواة — ھو تطبیق عادي في <span class="en-term">User Space</span> لكنه یلعب دور "الواسطة" بین المستخدم والنواة لتشغیل التطبیقات. عندما تكتب أمراً في الشل، فإن الشل نفسھ یقوم بعمل <span class="en-term">System Call</span> (مثل <code>fork()</code> ثم <code>exec()</code>) لیطلب من الكیرنل إنشاء عملیة جدیدة للتطبیق المطلوب.</p>
        </div>
      </div>

      <!-- Shell Types Table -->
      <div class="table-wrapper">
        <table>
          <thead>
            <tr>
              <th>الخاصية</th>
              <th>التفصیل</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>نوعه</td>
              <td>تطبیق عادي (<span class="en-term">Application/Process</span>)</td>
            </tr>
            <tr>
              <td>مكانه</td>
              <td><span class="en-term">User Space</span> — مثل أي تطبیق آخر</td>
            </tr>
            <tr>
              <td>وظیفته الأساسیة</td>
              <td>"الواسطة" التي نستخدمھا لطلب تشغیل التطبیقات الأخرى من الكیرنل</td>
            </tr>
            <tr>
              <td>كمترجم</td>
              <td>یمتلك لغة برمجة خاصة بھ تحتوي على شروط (if, while) وحلقات تكرار (for)</td>
            </tr>
            <tr>
              <td>أمثلة</td>
              <td class="en-cell">bash, sh, zsh — جمیعھا Implementations مختلفة لنفس مفھوم POSIX Shell</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════════════════════
     PAGE 8 — CHAPTER 7: INIT MANAGER
     ═══════════════════════════════════════════════════════ -->
<div class="page" id="ch7">
  <div class="page-header">
    <span class="course-name">Embedded Linux &amp; Yocto</span>
    <span class="chapter-name">الدرس الثاني: Linux Architecture in Details</span>
  </div>
  <div class="page-footer">
    <span>الإصدار 1.0</span>
    <span class="page-num">8</span>
  </div>
  <div class="page-content">
    <div class="section" id="s7-1">
      <div class="section-header">
        <div class="section-number">7</div>
        <div class="section-title">مدير الإقلاع الأول — Init Manager / Init Program</div>
      </div>

      <p>إذا كان كل تطبیق یحتاج إلى تطبیق قبله لتشغیلھ... فمن یشغل الأول في النظام؟!</p>

      <div class="callout callout-gray">
        <div class="callout-header">
          <span class="callout-icon">📌</span>
          تعريف
        </div>
        <div class="callout-body">
          <p><strong><span class="en-term">init</span>:</strong> ھو أول <span class="en-term">Process</span> یعمل في نظام لینكس إطلاقاً (ویكون رقم الـ <span class="en-term">ID</span> الخاص بھ دائماً <code>1</code>).</p>
        </div>
      </div>
    </div>

    <!-- How Init Works -->
    <div class="subsection" id="s7-2">
      <div class="subsection-title">كيف يعمل؟</div>

      <ol>
        <li>عندما یكتمل تحمیل الكیرنل في الذاكرة ویتعرف على العتاد.</li>
        <li>یبحث الكیرنل في وحدة التخزین (<span class="en-term">File System</span>) عن تطبیق یسمى <span class="en-term">init</span>.</li>
        <li>یقوم الكیرنل بتشغیل ھذا التطبیق يدویاً من داخلھ.</li>
        <li>تطبیق <span class="en-term">init</span> یأخذ عاتقھ مسؤولیة تشغیل كافة التطبیقات والخدمات (<span class="en-term">Services</span>) الأخرى في النظام (بما فیھا الشل <span class="en-term">Shell</span>).</li>
      </ol>

      <!-- Boot Sequence Diagram -->
      <div class="diagram-container">
        <div class="diagram-title">تسلسل الإقلاع — Boot Sequence</div>
        <div class="process-flow">
          <div class="pf-box pf-hw en">Hardware — التشغیل الفیزیائي للجهاز</div>
          <div class="pf-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14m-7-7l7 7 7-7"/></svg></div>
          <div class="pf-box pf-kernel en">Kernel — تحمیل النواة في الذاكرة والتعرف على العتاد</div>
          <div class="pf-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14m-7-7l7 7 7-7"/></svg></div>
          <div class="pf-box pf-scheduler en">Init (PID 1) — الكیرنل یشغل init يدویاً من داخلھ</div>
          <div class="pf-arrow"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14m-7-7l7 7 7-7"/></svg></div>
          <div class="pf-box pf-userspace en">Services &amp; Shell — init یشغل كافة التطبیقات والخدمات</div>
        </div>
      </div>

      <div class="callout callout-green">
        <div class="callout-header">
          <span class="callout-icon">✅</span>
          Key Takeaway — ما يجب أن تتذكر؟
        </div>
        <div class="callout-body">
          <p>النواة تشغل <span class="en-term">init</span> ثم <span class="en-term">init</span> یشغل الخدمات والتطبیقات.</p>
        </div>
      </div>
    </div>

    <!-- Init Managers Comparison -->
    <div class="subsection" id="s7-3">
      <div class="subsection-title">مقارنة تطبيقات إدارة الإقلاع — Init Managers Implementations</div>

      <p>بما أن لینكس مفتوح المصدر، ھناك عدة تطبیقات بُنیت لأداء دور الـ <span class="en-term">init</span> (تذكر: الكونسبت واحد، والتطبیقات مختلفة):</p>

      <div class="compare-wrapper">
        <div class="compare-label">مقارنة وجھ لوجھ</div>
        <div class="table-wrapper">
          <table class="comparison">
            <thead>
              <tr>
                <th>وجھ المقارنة</th>
                <th><span class="en-term">SysVinit</span></th>
                <th><span class="en-term">systemd</span></th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>النوع</td>
                <td>النظام القدیم والكلاسیكي (<span class="en-term">Sequential</span>)</td>
                <td>النظام الحدیث (والأشھر حالیاً) — <span class="en-term">Parallel</span></td>
              </tr>
              <tr>
                <td>كیف یشغل الخدمات؟</td>
                <td>یشغل الخدمات واحدة تلو الأخرى بالترتیب.</td>
                <td>یشغل الخدمات بالتوازي مما یسرع الإقلاع.</td>
              </tr>
              <tr>
                <td>الخصائص</td>
                <td>بسیط، خفیف، ومعقد.</td>
                <td>قوي، ومعقد.</td>
              </tr>
              <tr>
                <td>أین یُستخدم؟</td>
                <td>توزیعات قديمة</td>
                <td>أصبح المعیار الافتراضي في <span class="en-term">Yocto</span> و<span class="en-term">Ubuntu</span> و<span class="en-term">Fedora</span>.</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="callout callout-blue">
        <div class="callout-header">
          <span class="callout-icon">📘</span>
          Concept — مفھوم مهم
        </div>
        <div class="callout-body">
          <p><span class="en-term">systemd</span> مجرد <span class="en-term">Implementation</span> لمفھوم <span class="en-term">Init Manager</span> الـ.</p>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════════════════════
     PAGE 9 — CHAPTER 8: Q&A
     ═══════════════════════════════════════════════════════ -->
<div class="page" id="ch8">
  <div class="page-header">
    <span class="course-name">Embedded Linux &amp; Yocto</span>
    <span class="chapter-name">الدرس الثاني: Linux Architecture in Details</span>
  </div>
  <div class="page-footer">
    <span>الإصدار 1.0</span>
    <span class="page-num">9</span>
  </div>
  <div class="page-content">
    <div class="section">
      <div class="section-header">
        <div class="section-number">8</div>
        <div class="section-title">نصائح وأسئلة شائعة — Q&amp;A</div>
      </div>

      <!-- Q1 -->
      <div class="callout callout-purple">
        <div class="callout-header">
          <span class="callout-icon">🧠</span>
          سؤال: كيف يكتب التطبيق في المعالج سجلات CPU إذا كان لا يملك صلاحيات وصول للعتاد؟
        </div>
        <div class="callout-body">
          <p>التطبیق لا یلمس المعالج بیده — الكیرنل یوجه الـ <span class="en-term">CPU</span> لجلب الأوامر (<span class="en-term">Fetch</span>) من مساحة ذاكرة التطبیق في <span class="en-term">User Space</span>. المعالج ینفذ العادیة الأوامر (مثل وضع قیمة في <span class="en-term">Register</span>) طالما أنھا لا تخالف مستواه الأمني (<span class="en-term">EL0</span>) — ولیس التطبیق یقتحم المعالج.</p>
        </div>
      </div>

      <!-- Q2 -->
      <div class="callout callout-purple">
        <div class="callout-header">
          <span class="callout-icon">🧠</span>
          سؤال: هل يهم لغة البرمجة (C, C++, Rust) في Embedded Linux؟
        </div>
        <div class="callout-body">
          <p><strong>نعم، جداً:</strong></p>
          <ul class="primary-bullets">
            <li><strong><span class="en-term">C</span>:</strong> الأھم والأقوى على مستوى النظام (<span class="en-term">System Level</span>).</li>
            <li><strong><span class="en-term">C++</span>:</strong> قویة جداً في تطبیقات الـ <span class="en-term">User Space</span> الثقیلة.</li>
            <li><strong><span class="en-term">Rust</span>:</strong> بدأت تكتسب قوة ھائلة حتى داخل الكیرنل بسبب میزات الأمان القویة التي تمنع أخطاء الذاكرة.</li>
          </ul>
        </div>
      </div>

      <!-- Book Recommendation -->
      <div class="callout callout-orange">
        <div class="callout-header">
          <span class="callout-icon">💡</span>
          Tip — كتاب یُنصح بھ بشدة
        </div>
        <div class="callout-body">
          <div class="book-rec">
            <div class="book-cover">Mastering Embedded Linux Programming</div>
            <div class="book-info">
              <div class="book-title">Mastering Embedded Linux Programming</div>
              <div class="book-desc">المدرب یعتبره كتاباً "مقدساً" — يجب قراءتھ من الغلاف للغلاف لكل من یرید الاحتراف الحقیقي في ھذا المجال.</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Golden Advice -->
      <div class="golden-advice">
        <div class="golden-advice-title">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="#92400e"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
          النصیحة الذھبیة من المدرب
        </div>
        <div class="golden-advice-body">
          <p>استوعبوا الأساسیات والمفاھیم الفلسفیة لأنظمة البطیئة بالصبر — لا یترككم الذكاء الاصطناعي بالتعلم، وتركیز لأن من یفھم ھذه الأساسیات (مثل الـ <span class="en-term">Architecture</span> والـ <span class="en-term">System calls</span>) سیسیطر جداً ویسرع في المراحل المتقدمة (مثل كتابة الـ <span class="en-term">Drivers</span>).</p>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════════════════════
     PAGE 10 — QUICK REVIEW
     ═══════════════════════════════════════════════════════ -->
<div class="page" id="qr">
  <div class="page-header">
    <span class="course-name">Embedded Linux &amp; Yocto</span>
    <span class="chapter-name">الدرس الثاني: Linux Architecture in Details</span>
  </div>
  <div class="page-footer">
    <span>الإصدار 1.0</span>
    <span class="page-num">10</span>
  </div>
  <div class="page-content">
    <div class="quick-review">
      <div class="quick-review-title">
        <svg viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/></svg>
        مراجعة سريعة — Quick Review
      </div>

      <!-- Main Concepts -->
      <div class="qr-section">
        <div class="qr-section-title">
          <span class="qr-icon" style="background:var(--primary-bg);color:var(--primary);">📋</span>
          المفاھیم الرئیسیة
        </div>
        <ul class="qr-list">
          <li>نظام لینكس ینقسم إلى ثلاث طبقات: <span class="en-term">User Space</span>، <span class="en-term">Kernel Space</span>، <span class="en-term">Hardware</span>.</li>
          <li>الفصل بین المساحتین مدعوم من العتاد نفسه عبر <span class="en-term">Exception Levels (EL0-EL3)</span> في معالجات ARM.</li>
          <li>التطبیق لا یعمل مباشرة — النواة تحوله إلى <span class="en-term">Process</span> قابل للجدولة.</li>
          <li>التواصل بین <span class="en-term">User Space</span> و<span class="en-term">Kernel Space</span> یتم فقط عبر <span class="en-term">System Calls</span> باستخدام المقاطعات (<span class="en-term">Interrupts</span>).</li>
          <li>الـ <span class="en-term">ABI</span> ھو القانون الثابت الذي یحدد أرقام الـ <span class="en-term">Syscalls</span> وطریقة استدعائھا — لا یتغیر أبداً.</li>
          <li>الشل ھو تطبیق عادي في <span class="en-term">User Space</span> یلعب دور "الواسطة" لتشغیل التطبیقات الأخرى.</li>
          <li><span class="en-term">init</span> (PID 1) ھو أول عملیة في النظام — الكیرنل یشغله ثم ھو یشغل باقي الخدمات.</li>
          <li><span class="en-term">systemd</span> ھو <span class="en-term">Implementation</span> حديث للـ <span class="en-term">Init Manager</span> یشغل الخدمات بالتوازي.</li>
        </ul>
      </div>

      <!-- Important Definitions -->
      <div class="qr-section">
        <div class="qr-section-title">
          <span class="qr-icon" style="background:var(--gray-100);color:var(--gray-700);">📌</span>
          تعریفات مهمة
        </div>
        <ul class="qr-list">
          <li><strong><span class="en-term">ISA</span>:</strong> الھندسي التصمیم الذي یحدد شكل الأوامر والسجلات الخاصة بالمعالج.</li>
          <li><strong><span class="en-term">Hypervisor</span>:</strong> نظام یمتلك صلاحیات أعلى من الـ <span class="en-term">Kernel</span> لتشغیل أنظمة تشغیل عدة على نفس العتاد.</li>
          <li><strong><span class="en-term">System Call</span>:</strong> طلب رسمي واحد من التطبیق للنواة لأداء مھمة تحتاج صلاحیات.</li>
          <li><strong><span class="en-term">ABI</span>:</strong> قانون مقدس وثابت یحدد أرقام الـ <span class="en-term">Syscalls</span> وطریقة استدعائھا.</li>
          <li><strong><span class="en-term">Process</span>:</strong> ھویة/ملف ینشئه الكیرنل للتطبیق في <span class="en-term">Kernel Space</span> بینما یبقى الكود معزولاً في <span class="en-term">User Space</span>.</li>
          <li><strong><span class="en-term">init</span>:</strong> أول <span class="en-term">Process</span> في نظام لینكس ورقم <span class="en-term">ID</span> الخاص بھ دائماً <code>1</code>.</li>
        </ul>
      </div>

      <!-- Common Mistakes -->
      <div class="qr-section">
        <div class="qr-section-title">
          <span class="qr-icon" style="background:var(--danger-bg);color:var(--danger);">✗</span>
          أخطاء شائعة
        </div>
        <ul class="qr-list warn">
          <li>الاعتقاد بأن التطبیقات تتحكم مباشرة في <span class="en-term">Hardware</span> — مستحیل ویمنعھ النظام.</li>
          <li>الاعتقاد بأن التطبیق عند التشغیل ینقل إلى الكیرنل — الصحیح أن الكیرنل ینشئ لھ <span class="en-term">Process</span> فقط.</li>
          <li>خلط مفھوم <span class="en-term">API</span> (واجھة الكود المصدر) مع <span class="en-term">ABI</span> (واجھة التعامل مع الـ Binary).</li>
          <li>الاعتقاد بأن الشل جزء من النواة — ھو تطبیق عادي في <span class="en-term">User Space</span>.</li>
        </ul>
      </div>

      <!-- Interview Notes -->
      <div class="qr-section">
        <div class="qr-section-title">
          <span class="qr-icon" style="background:var(--warning-bg);color:var(--warning);">💬</span>
          ملاحظات للمقابلات
        </div>
        <ul class="qr-list q">
          <li>"كیف يتواصل <span class="en-term">User Space</span> مع <span class="en-term">Kernel Space</span>؟" — سؤال شھیر في المقابلات، والإجابة: عبر <span class="en-term">System Calls</span> باستخدام المقاطعات.</li>
          <li>كن مستعداً لشرح خطوات الـ <span class="en-term">Syscall</span> الخمسة بالتفصیل.</li>
          <li>افرق بین <span class="en-term">Type 1 Hypervisor</span> و<span class="en-term">Type 2 Hypervisor</span> مع أمثلة.</li>
          <li>اشرح لماذا <span class="en-term">ABI</span> ثابت ولا یتغیر أبداً.</li>
          <li>ما الفرق بین <span class="en-term">SysVinit</span> و<span class="en-term">systemd</span>؟</li>
        </ul>
      </div>

      <!-- Memory Tips -->
      <div class="qr-section">
        <div class="qr-section-title">
          <span class="qr-icon" style="background:var(--accent-bg);color:var(--accent);">★</span>
          نصائح للحفظ
        </div>
        <ul class="qr-list tip">
          <li><strong>3 طبقات:</strong> User → Kernel → Hardware — فكّر فیھا كطبقات بناء من الأعلى للأسفل.</li>
          <li><strong>EL0-EL3:</strong> كلما زاد الرقم زادت الصلاحیات — 0 = مستخدم عادي، 3 = أعلى سلطة.</li>
          <li><strong>المواطن والمدیر:</strong> التطبیق = مواطن لا یدخل المكتب، لكنه یصبح موظف (<span class="en-term">Process</span>) یعمل داخل النظام.</li>
          <li><strong>printf → write:</strong> <code>printf</code> واجھة مبسطة، <span class="en-term">write</span> ھو الـ <span class="en-term">Syscall</span> الحقیقي.</li>
          <li><strong>الإقلاع:</strong> Hardware → Kernel → init (PID 1) → Services → Shell → التطبیقات.</li>
        </ul>
      </div>

      <!-- Exam Tips -->
      <div class="qr-section">
        <div class="qr-section-title">
          <span class="qr-icon" style="background:var(--success-bg);color:var(--success);">🎯</span>
          نصائح للامتحانات
        </div>
        <ul class="qr-list tip">
          <li>ركز على فرق <span class="en-term">EL0</span> و<span class="en-term">EL1</span> — الأكثر استخداماً في التطبیقات العملیة.</li>
          <li>احفظ خطوات الـ <span class="en-term">Syscall</span> بالترتیب: تجھیز → سجلات → مقاطعة → توقف → تنفیذ.</li>
          <li>اعرف لماذا <span class="en-term">ABI</span> مهم وماذا یحدث لو تغیر.</li>
          <li>افهم تسلسل الإقلاع: من أین تبدأ النواة ومن ینشئ من.</li>
        </ul>
      </div>

      <!-- Revision Checklist -->
      <div class="qr-section">
        <div class="qr-section-title">
          <span class="qr-icon" style="background:var(--purple-bg);color:var(--purple);">✓</span>
          قائمة المراجعة — Revision Checklist
        </div>
        <ul class="checklist">
          <li><span class="check-box"></span> أستطيع رسم معماریة لینكس الثلاثیة وأشرح فصل كل طبقة</li>
          <li><span class="check-box"></span> أشرح مستویات <span class="en-term">Exception Levels</span> الأربعة في ARM</li>
          <li><span class="check-box"></span> أفرق بین <span class="en-term">Type 1</span> و<span class="en-term">Type 2 Hypervisor</span></li>
          <li><span class="check-box"></span> أشرح مثال المواطن والمدیر لتوضیح التواصل بین المساحتین</li>
          <li><span class="check-box"></span> أشرح خطوات تحویل التطبیق إلى <span class="en-term">Process</span></li>
          <li><span class="check-box"></span> أشرح خطوات الـ <span class="en-term">Syscall</span> الخمسة بالتفصیل</li>
          <li><span class="check-box"></span> أفهم العلاقة بین <code>printf</code> و<span class="en-term">write</span></li>
          <li><span class="check-box"></span> أعرف ما ھو <span class="en-term">ABI</span> ولماذا لا یتغیر</li>
          <li><span class="check-box"></span> أفهم دور الشل وأنه تطبیق عادي</li>
          <li><span class="check-box"></span> أشرح تسلسل الإقلاع والـ <span class="en-term">init</span></li>
          <li><span class="check-box"></span> أفرق بین <span class="en-term">SysVinit</span> و<span class="en-term">systemd</span></li>
          <li><span class="check-box"></span> أفهم أهمیة لغة C في <span class="en-term">Embedded Linux</span></li>
        </ul>
      </div>
    </div>
  </div>
</div>

<script>
// Smooth scroll navigation for TOC
function scrollToSection(id) {
  const el = document.getElementById(id);
  if (el) {
    el.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
}

// Add hover effects to checklist items
document.querySelectorAll('.checklist li').forEach(item => {
  item.addEventListener('click', function() {
    const box = this.querySelector('.check-box');
    if (box.style.background === 'var(--success)') {
      box.style.background = '';
      box.innerHTML = '';
      this.style.textDecoration = 'none';
      this.style.opacity = '1';
    } else {
      box.style.background = 'var(--success)';
      box.innerHTML = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3"><path d="M20 6L9 17l-5-5"/></svg>';
      this.style.textDecoration = 'line-through';
      this.style.opacity = '0.6';
    }
  });
  item.style.cursor = 'pointer';
  item.style.transition = 'all 0.2s ease';
});
</script>

</body>
</html>
