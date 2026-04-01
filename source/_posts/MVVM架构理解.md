---
title: MVVM架构理解
date: 2026-01-14 11:05:14
tags:
---

## MVVM 架构说明

### 什么是 MVVM 架构？

MVVM（Model-View-ViewModel）是一种架构模式，将代码分为三层：

- Model：数据和业务逻辑

- View：UI 界面展示

- ViewModel：连接 View 和 Model，处理 UI 逻辑，通过数据绑定与 View 交互

### 架构关系图：

┌──────────┐     ┌──────────────┐     ┌──────────┐

│  View  │ ◄────► │ ViewModel  │ ◄────► │ Model  │

│ (视图) │ 绑定   │ (视图模型)  │ 获取   │ (数据模型) │

└──────────┘     └──────────────┘     └──────────┘

  UI层        业务逻辑层        数据层

------

## 订单列表中的 MVVM 对应关系

### M (Model) - 数据模型层

负责数据定义、接口调用、数据存储：

#### 1. 数据模型类OrderModel.ktLines 149-149@JvmField val expLicenceNames: String? = null,

- OrderModel：订单数据模型

- OrderInfoResult：接口返回的数据结构

#### 2. 接口服务ApiService.javaLines 1057-1070@GET(URLs.SEARCHORDERNEW)Observable<OrderInfoResult> searchOrderNew(    @Query("orderCodeSplits") String orderCodes,    @Query("orderState") String orderState,    // ...);

- ApiService：定义接口

- ApiServiceInstance：获取 API 实例

- URLs：接口路径常量

#### 3. 数据仓库（Repository，可选）

- 封装数据获取逻辑，统一数据源

------

### V (View) - 视图层

负责 UI 展示和用户交互：

#### 1. Activity/FragmentOrderStateActivity.javaLines 43-43public class OrderStateActivity extends BaseMVVMActivity<ActivityOrderStateBinding, OrderStateViewModel> implements IOrderStateDataNew {

- OrderStateActivity：订单状态页面容器

OrderListNewFragment.javaLines 16-16

public class OrderListNewFragment extends LazyFragment<FragmentOrderListNewBinding, OrderListNewViewModel> {

- OrderListNewFragment：订单列表 Fragment

#### 2. 布局文件

- activity_order_state.xml：Activity 布局

- fragment_order_list_new.xml：Fragment 布局

- item_order_list_new.xml：列表 Item 布局

#### 3. DataBindingOrderListNewFragment.javaLines 54-54return DataBindingUtil.bind(root);OrderListNewFragment.javaLines 67-67mViewDataBinding.setViewmodel(viewModel);

- FragmentOrderListNewBinding：自动生成的绑定类

- 通过 mViewDataBinding.setViewmodel(viewModel) 绑定 ViewModel

------

### VM (ViewModel) - 视图模型层

连接 View 和 Model，处理 UI 相关业务逻辑：

#### 1. OrderListNewViewModelOrderListNewViewModel.javaLines 70-74public class OrderListNewViewModel extends BaseObservable implements SimpleFragmentLifecycle {  private Fragment fragment;  private FragmentOrderListNewBinding binding;    public String totalPrice = "¥0";

职责：

- 数据

  获取：调用接口获取订单列表

  OrderListNewViewModel.javaLines 538-550

  disposable = ApiServiceInstance.getInstance().searchOrderNew(

  ​        orderCodes,

  ​        orderState,

  ​        page,

  ​        30,

  ​        event.supplierId,

  ​        event.branchId,

  ​        event.custNameKwd,

  ​        event.dateType,

  ​        event.startTime,

  ​        event.endTime,

  ​        event.validOrderFlag

  ​    )

- 数据处理：转换、格式化数据

- UI 状态：管理 loading、错误等状态

- 列表适配

  ：创建和管理 Adapter

  OrderListNewViewModel.javaLines 119-119

  mAdapter = new BaseQuickAdapter<OrderModel, BaseViewHolder>(R.layout.item_order_list_new) {

#### 2. OrderStateViewModelOrderStateViewModel.javaLines 47-60public class OrderStateViewModel extends BaseObservable {  private Context context;  public ActivityOrderStateBinding binding;  public OrderStateActivity.PagerAdapter pagerAdapter;  // ...  public void init(BaseActivity baseActivity, Context context, ActivityOrderStateBinding binding, int currentPage) {    // ...    this.pagerAdapter = new OrderStateActivity.PagerAdapter(baseActivity.getSupportFragmentManager());

职责：

- 页面逻辑：管理页签切换、筛选条件

- ViewPager 适配：创建 PagerAdapter

------

## MVVM 数据流向

### 数据获取流程：

用户操作/页面加载

  ↓

View (Fragment.initData)

  ↓ 调用

ViewModel.refresh()

  ↓ 调用

ApiServiceInstance.searchOrderNew() [Model层]

  ↓ 返回

OrderInfoResult [Model]

  ↓ 处理

ViewModel.replaceData() [ViewModel层]

  ↓ 更新

Adapter.notifyDataSetChanged()

  ↓ 渲染

View 显示订单列表 [View层]

### 代码示例：

OrderListNewFragment.javaLines 67-67

mViewDataBinding.setViewmodel(viewModel);

OrderListNewFragment.javaLines 87-87

viewModel.refresh();

OrderListNewViewModel.javaLines 538-567

disposable = ApiServiceInstance.getInstance().searchOrderNew(...)

  .subscribe(orderInfoResult -> {

​    if (orderInfoResult.code == 1) {

​      // ...

​      mAdapter.replaceData(orderInfoResult.data.orderList);

​    }

  });

------

## MVVM 的优势

1. 关注点分离：UI、业务逻辑、数据分离

1. 可测试性：ViewModel 独立于 View，易于单元测试

1. 可维护性：代码结构清晰，易于维护

1. 数据绑定：自动同步 UI 和数据，减少手动更新代码

------

## 总结

在订单列表中的对应关系：

| 层级           | 具体组件                                           | 文件位置                          |
| :------------- | :------------------------------------------------- | :-------------------------------- |
| M (Model)      | OrderModel、OrderInfoResult、ApiService            | data/、cgi/                       |
| V (View)       | OrderStateActivity、OrderListNewFragment、布局 XML | activity/、fragment/、res/layout/ |
| VM (ViewModel) | OrderStateViewModel、OrderListNewViewModel         | mvvm/vm/                          |

这种架构使代码分层清晰，职责明确，便于维护和扩展。