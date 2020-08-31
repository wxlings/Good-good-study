public class Utils {

    /**
     * 获取运行时环境是否可调试
     */
    public boolean getRuntimeIsDebug(Context context) {
        ApplicationInfo applicationInfo = context.getApplicationInfo();
        return applicationInfo != null && ((applicationInfo.flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0);
    }
}