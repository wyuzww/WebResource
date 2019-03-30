package com.ethan.entity;

public class Pagination {
  
  private long curPage;

  private long pageSize;

  private long pageNumber;

  private long items;

  public Pagination() {
  }

  public Pagination(long curPage, long pageSize, long pageNumber, long items) {
    this.curPage = curPage;
    this.pageSize = pageSize;
    this.pageNumber = pageNumber;
    this.items = items;
  }

  public long getCurPage() {
    return curPage;
  }

  public void setCurPage(long curPage) {
    this.curPage = curPage;
  }

  public long getPageSize() {
    return pageSize;
  }

  public void setPageSize(long pageSize) {
    this.pageSize = pageSize;
  }

  public long getPageNumber() {
    return pageNumber;
  }

  public void setPageNumber(long pageNumber) {
    this.pageNumber = pageNumber;
  }

  public long getItems() {
    return items;
  }

  public void setItems(long items) {
    this.items = items;
  }

  @Override
  public String toString() {
    return "Pagination{" +
            "curPage=" + curPage +
            ", pageSize=" + pageSize +
            ", pageNumber=" + pageNumber +
            ", items=" + items +
            '}';
  }
}
