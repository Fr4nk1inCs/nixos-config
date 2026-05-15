/**
 * Custom footer — session metadata in the bottom bar.
 *
 * Shows model (thinking-level), context usage, token counts, cost (RMB for
 * DeepSeek, USD otherwise), CWD, and git branch. Context window is color-
 * coded by fill level.
 */

import type { AssistantMessage } from "@mariozechner/pi-ai";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";

// ---------------------------------------------------------------------------
// DeepSeek RMB pricing (¥ / million tokens).  Update when the 75%-off sale ends.
// ---------------------------------------------------------------------------

const RMB_RATES: Record<
	string,
	{ cacheRead: number; input: number; output: number }
> = {
	"deepseek-v4-pro": { cacheRead: 0.1, input: 12, output: 24 },
	"deepseek-v4-flash": { cacheRead: 0.02, input: 1, output: 2 },
};

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const fmt = (n: number) =>
	n < 1000
		? `${n}`
		: n < 1_000_000
			? `${(n / 1000).toFixed(1)}k`
			: `${(n / 1_000_000).toFixed(1)}M`;

const abbrevCwd = (cwd: string) => {
	const home = process.env.HOME;
	return home && cwd.startsWith(home) ? "~" + cwd.slice(home.length) : cwd;
};

const costStr = (
	modelId: string,
	t: { input: number; output: number; cacheRead: number },
	usd: number,
) => {
	const r = RMB_RATES[modelId];
	return r
		? `¥${((r.cacheRead * t.cacheRead + r.input * t.input + r.output * t.output) / 1_000_000).toFixed(3)}`
		: `$${usd.toFixed(3)}`;
};

// ---------------------------------------------------------------------------
// Extension
// ---------------------------------------------------------------------------

export default function (pi: ExtensionAPI) {
	let branch: string | undefined;

	pi.on("session_start", async (_event, ctx) => {
		const git = await pi
			.exec("git", ["branch", "--show-current"], { cwd: ctx.cwd })
			.catch(() => undefined);
		branch = git?.stdout.trim() || undefined;

		ctx.ui.setFooter((tui, thm, footerData) => ({
			dispose: footerData.onBranchChange(() => {
				branch = footerData.getGitBranch() ?? undefined;
				tui.requestRender();
			}),

			render(width: number): string[] {
				const usage = ctx.getContextUsage();
				const pct = usage?.percent ?? null;

				const tokens = { input: 0, output: 0, cacheRead: 0 };
				let usd = 0;
				for (const e of ctx.sessionManager.getBranch()) {
					if (e.type === "message" && e.message.role === "assistant") {
						const u = (e.message as AssistantMessage).usage;
						tokens.input += u.input;
						tokens.output += u.output;
						tokens.cacheRead += u.cacheRead;
						usd += u.cost.total;
					}
				}

				const ctxC = (s: string) =>
					pct === null
						? thm.fg("dim", s)
						: pct >= 90
							? thm.fg("error", s)
							: pct >= 75
								? thm.fg("warning", s)
								: pct >= 50
									? thm.fg("muted", s)
									: thm.fg("dim", s);

				const model = ctx.model;
				const modelId = model ? `${model.provider}/${model.id}` : "no model";

				const segs = [
					thm.fg("accent", thm.bold(modelId)) +
						" " +
						thm.fg("muted", `(${pi.getThinkingLevel()})`),
					ctxC(
						`ctx ${pct !== null ? Math.round(pct) + "%" : "?"}${usage?.contextWindow ? "/" + fmt(usage.contextWindow) : ""}`,
					),
					thm.fg(
						"dim",
						`${tokens.cacheRead > 0 ? `↩${fmt(tokens.cacheRead)} ` : ""}↑${fmt(tokens.input)} ↓${fmt(tokens.output)} (${costStr(model?.id ?? "", tokens, usd)})`,
					),
				];

				const left = segs.join(" · ");

				let right = thm.fg("muted", abbrevCwd(ctx.cwd));
				if (branch) right += thm.fg("dim", ` (${branch})`);

				return [
					truncateToWidth(
						left +
							" ".repeat(
								Math.max(1, width - visibleWidth(left) - visibleWidth(right)),
							) +
							right,
						width,
					),
				];
			},

			invalidate() {},
		}));
	});
}
