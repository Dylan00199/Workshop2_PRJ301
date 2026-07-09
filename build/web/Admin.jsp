<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Service.ViewHistoryService" %>
<%@ page import="Model.ViewHistory" %>
<%@ page import="Utilities.SegmentationUtils" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>



<%
    ViewHistoryService vhs = new ViewHistoryService();
    List<ViewHistory> history;
    List<String> accounts;
    Map<String, Double> avgPrices = new LinkedHashMap<String, Double>();
    Map<String, String> segments = new LinkedHashMap<String, String>();
    try {
        history = vhs.listAll();
        accounts = vhs.listViewedAccounts();
        for (String acc : accounts) {
            Double avg = vhs.getAverageViewedPrice(acc);
            if (avg == null) {
                avg = 0.0;
            }
            avgPrices.put(acc, avg);
            segments.put(acc, SegmentationUtils.classify(avg));
        }
    } finally {
        vhs.close();
    }
    pageContext.setAttribute("history", history);
    pageContext.setAttribute("avgPrices", avgPrices);
    pageContext.setAttribute("segments", segments);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>
        <style>
            .page-content {
                padding: 24px 32px;
            }
            h1.page-title {
                font-size: 28px;
                font-weight: 400;
                color: #222;
                margin-bottom: 8px;
            }
            .section-sub {
                font-size: 13px;
                color: #888;
                margin-bottom: 24px;
            }

            .dashboard-grid {
                display: grid;
                grid-template-columns: 1fr;
                gap: 28px;
                max-width: 1100px;
            }

            .panel {
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                overflow: hidden;
                background: #fff;
            }
            .panel-header {
                padding: 14px 20px;
                border-bottom: 1px solid #f0f0f0;
                background: #fafafa;
            }
            .panel-header h2 {
                font-size: 14px;
                font-weight: 700;
                color: #333;
                text-transform: uppercase;
                letter-spacing: 0.4px;
                margin: 0;
            }

            .data-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
            }
            .data-table th {
                text-align: left;
                padding: 9px 14px;
                border-bottom: 2px solid #dee2e6;
                color: #555;
                font-weight: 600;
                font-size: 13px;
                background: #f8f9fa;
            }
            .data-table td {
                padding: 9px 14px;
                border-bottom: 1px solid #f0f0f0;
            }
            .data-table tr:last-child td {
                border-bottom: none;
            }
            .data-table tr:hover td {
                background: #f8f9fa;
            }

            .segment-badge {
                display: inline-block;
                padding: 2px 10px;
                border-radius: 10px;
                font-size: 12px;
                font-weight: 700;
            }
            .segment-low    {
                background: #fdf2f2;
                color: #c0392b;
            }
            .segment-middle {
                background: #fff3cd;
                color: #856404;
            }
            .segment-high   {
                background: #eafaf1;
                color: #1e8449;
            }

            .empty-row td {
                text-align: center;
                padding: 32px 0;
                color: #aaa;
                font-size: 14px;
            }

            .scroll-box {
                max-height: 420px;
                overflow-y: auto;
            }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">
            <h1 class="page-title">Admin dashboard</h1>
            <p class="section-sub">Product view tracking &amp; user income segmentation</p>

            <div class="dashboard-grid">

                <%-- ===== USER SEGMENTATION ===== --%>
                <div class="panel">
                    <div class="panel-header"><h2>User income segmentation</h2></div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Account</th>
                                <th>Avg. viewed product price (VND)</th>
                                <th>Segment</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty segments}">
                                    <tr class="empty-row"><td colspan="3">No view data recorded yet.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="entry" items="${segments}">
                                        <tr>
                                            <td><c:out value="${entry.key}"/></td>
                                            <td><fmt:formatNumber
                                                    value="${avgPrices[entry.key]}" pattern="#,##0"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${entry.value == 'Low Income'}">
                                                        <span class="segment-badge segment-low">${entry.value}</span>
                                                    </c:when>
                                                    <c:when test="${entry.value == 'Middle Income'}">
                                                        <span class="segment-badge segment-middle">${entry.value}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="segment-badge segment-high">${entry.value}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <%-- ===== RAW VIEW HISTORY ===== --%>
                <div class="panel">
                    <div class="panel-header"><h2>Product view history</h2></div>
                    <div class="scroll-box">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Account</th>
                                    <th>Product ID</th>
                                    <th>Price at view (VND)</th>
                                    <th>Viewed at</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty history}">
                                        <tr class="empty-row"><td colspan="4">No product views recorded yet.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="h" items="${history}">
                                            <tr>
                                                <td><c:out value="${h.account}"/></td>
                                                <td><c:out value="${h.productId}"/></td>
                                                <td><fmt:formatNumber
                                                        value="${h.priceAtView}" pattern="#,##0"/></td>
                                                <td>
                                                    <fmt:formatDate value="${h.viewedAt}" pattern="dd/MM/yyyy - HH:mm:ss" />
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>

    </body>
</html>
